#!/usr/bin/env python3
"""Extract morphological data from UniMorph German for statistical analysis.

This script fetches German morphological data from the UniMorph project and
creates two form-level intermediate datasets:

1. **Genitive Dataset**: Retains detected ``-s`` and ``-es`` genitive forms
   for German masculine and neuter noun lemmas. The downstream R script
   reduces alternative forms to lexeme-level suffix-attestation indicators.

2. **Plural Suffix Dataset**: Tests whether plural suffix choice
   (-e/-en/-er/-s/-ø) is independent of grammatical gender in German nouns.

The script performs string-based morphological analysis to detect suffixes,
count syllables, and identify phonological patterns. Output is saved in
long-form CSV format suitable for statistical analysis in R.

Notes
-----
**Dataset 1: Genitive Allomorphy** (for Fisher's Exact Test)

Research Question: Is stem-final sibilance associated with the attestation of
an ``-es`` genitive form in the derived lexeme table?

The extractor retains forms for which string comparison identifies ``-s`` or
``-es``. A lemma may have both forms in UniMorph. The downstream analysis thus
uses attestation rather than treating every row as an independent suffix
choice.

Tests association between:
    - Stem-final sibilance
    - Attestation of a detected ``-es`` form

**Dataset 2: Plural Suffix Types** (for Chi-Squared Test)

Research Question: Is plural suffix choice independent of grammatical gender?

German plural suffixes:
    -e:  "Hund" → "Hunde" (dogs)
    -en: "Katze" → "Katzen" (cats)
    -er: "Kind" → "Kinder" (children)
    -s:  "Auto" → "Autos" (cars)
    -ø:  "Vater" → "Väter" (umlaut only)

Tests contingency: Gender (MASC/FEM/NEUT) × Plural Suffix

**String Analysis Methods:**
    - Syllable counting via vowel cluster detection
    - Suffix detection by comparing lemma and inflected forms
    - Sibilant detection (s, z, sch, ß, x)
    - Umlaut detection (ä/ö/ü vs a/o/u)

Examples
--------
Run the script to fetch data and create CSV files::

    $ python fetch_unimorph_data.py

Output files are created in the assignment's ``data`` directory:
    - unimorph_genitive.csv
    - unimorph_plural.csv

See Also
--------
UniMorph Project: https://unimorph.github.io/
Pinned German source revision: d226d2112d3490d8f04ece10d4538123d4297a39
"""

import re
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Dict, List, Optional, Union
from urllib.request import urlopen

import pandas as pd


class LemmaInfo(dict):
    """Type for lemma information storage."""

    def __init__(self) -> None:
        """Initialize lemma info with default values."""
        super().__init__()
        self['gender'] = None
        self['singular'] = None
        self['plural'] = []

def parse_unimorph_file(url: str) -> List[Dict[str, Union[str, List[str]]]]:
    """
    Parse UniMorph TSV format.

    Parameters
    ----------
    url : str
        URL to the UniMorph TSV file.

    Returns
    -------
    List[Dict[str, Union[str, List[str]]]]
        List of dictionaries containing parsed morphological data.
        Each dict has keys: 'lemma', 'inflected_form', 'feature_bundle', 'features'.

    Notes
    -----
    Format: lemma \t inflected_form \t feature_bundle
    Example: go	went	V;PST
    """
    data: List[Dict[str, Union[str, List[str]]]] = []

    try:
        with urlopen(url) as response:
            for line_num, line in enumerate(response, 1):
                try:
                    line_str: str = line.decode('utf-8').strip()

                    # Skip empty lines and comments
                    if not line_str or line_str.startswith('#'):
                        continue

                    # Parse TSV
                    parts: List[str] = line_str.split('\t')
                    if len(parts) >= 3:
                        lemma: str = parts[0]
                        inflected: str = parts[1]
                        features: str = parts[2]

                        # Parse feature bundle (semicolon-separated)
                        feature_list: List[str] = [f.strip() for f in features.split(';') if f.strip()]

                        data.append({
                            'lemma': lemma,
                            'inflected_form': inflected,
                            'feature_bundle': features,
                            'features': feature_list
                        })
                except Exception as e:
                    print(f"Warning: Error parsing line {line_num}: {e}", file=sys.stderr)
                    continue

    except Exception as e:
        print(f"Error fetching data: {e}", file=sys.stderr)
        return []

    return data

def count_syllables(word: str) -> int:
    """
    Approximate syllable count by counting vowel clusters.

    Parameters
    ----------
    word : str
        German word to count syllables in.

    Returns
    -------
    int
        Approximate number of syllables in the word.

    Notes
    -----
    German vowels: a, e, i, o, u, ä, ö, ü, y
    Diphthongs like 'ei', 'au', 'eu' count as one syllable.
    """
    word_lower: str = word.lower()
    # Replace common diphthongs with single character
    word_normalized: str = re.sub(r'ei|au|eu|äu|ie', 'V', word_lower)
    # Count remaining vowel clusters
    vowels: List[str] = re.findall(r'[aeiouyäöü]+', word_normalized)
    return len(vowels)

def ends_in_sibilant(word: str) -> bool:
    """
    Check if word ends in a sibilant.

    Parameters
    ----------
    word : str
        German word to check.

    Returns
    -------
    bool
        True if word ends in a sibilant (s, z, ß, sch, x), False otherwise.
    """
    word_lower: str = word.lower()
    return bool(re.search(r'(s|z|ß|sch|x)$', word_lower))

def detect_genitive_suffix(lemma: str, genitive_form: str) -> Optional[str]:
    """
    Detect genitive suffix by comparing lemma and genitive form.

    Parameters
    ----------
    lemma : str
        Base form of the noun.
    genitive_form : str
        Genitive form of the noun.

    Returns
    -------
    Optional[str]
        The genitive suffix ('s' or 'es'), or None if no suffix detected.
    """
    lemma_lower: str = lemma.lower()
    genitive_lower: str = genitive_form.lower()

    # Check if genitive ends with -es
    if genitive_lower.endswith('es') and not lemma_lower.endswith('es'):
        # Verify it's a suffix, not part of the stem
        if genitive_lower[:-2] == lemma_lower or genitive_lower[:-2] + 'e' == lemma_lower:
            return 'es'

    # Check if genitive ends with -s
    if genitive_lower.endswith('s') and not lemma_lower.endswith('s'):
        if genitive_lower[:-1] == lemma_lower:
            return 's'

    return None

def detect_plural_suffix(lemma: str, plural_form: str) -> str:
    """
    Detect plural suffix by comparing singular lemma and plural form.

    Parameters
    ----------
    lemma : str
        Base form (singular) of the noun.
    plural_form : str
        Plural form of the noun.

    Returns
    -------
    str
        The plural suffix type: 'e', 'en', 'er', 's', 'ø' (zero/umlaut only), or 'other'.

    Notes
    -----
    Handles umlaut: if only umlaut changes with no overt suffix, returns 'ø'.
    """
    lemma_lower: str = lemma.lower()
    plural_lower: str = plural_form.lower()

    # If identical, it's zero marking
    if lemma_lower == plural_lower:
        return 'ø'

    # Check for umlaut (a→ä, o→ö, u→ü)
    has_umlaut: bool = False
    lemma_no_umlaut: str = lemma_lower.replace('ä', 'a').replace('ö', 'o').replace('ü', 'u')
    plural_no_umlaut: str = plural_lower.replace('ä', 'a').replace('ö', 'o').replace('ü', 'u')

    if lemma_no_umlaut != lemma_no_umlaut or plural_no_umlaut != plural_no_umlaut:
        # There's umlaut involved
        has_umlaut = any(v in plural_lower for v in ['ä', 'ö', 'ü']) and \
                     any(v in lemma_lower for v in ['a', 'o', 'u'])

    # Check common suffixes
    if plural_lower.endswith('en') and not lemma_lower.endswith('en'):
        if plural_lower[:-2] == lemma_lower or plural_lower[:-2] == lemma_no_umlaut:
            return 'en'

    if plural_lower.endswith('er') and not lemma_lower.endswith('er'):
        if plural_lower[:-2] == lemma_lower or plural_lower[:-2] == lemma_no_umlaut:
            return 'er'

    if plural_lower.endswith('e') and not lemma_lower.endswith('e'):
        if plural_lower[:-1] == lemma_lower or plural_lower[:-1] == lemma_no_umlaut:
            return 'e'

    if plural_lower.endswith('s') and not lemma_lower.endswith('s'):
        if plural_lower[:-1] == lemma_lower:
            return 's'

    # Check for umlaut-only plural (no overt suffix)
    if has_umlaut and plural_no_umlaut == lemma_no_umlaut:
        return 'ø'

    # Couldn't determine
    return 'other'

def create_genitive_allomorphy_dataset(data: List[Dict[str, Union[str, List[str]]]]) -> pd.DataFrame:
    """
    Create dataset for genitive allomorphy analysis.

    Parameters
    ----------
    data : List[Dict[str, Union[str, List[str]]]]
        Parsed UniMorph data containing inflected forms and features.

    Returns
    -------
    pd.DataFrame
        DataFrame with columns: lemma, genitive_form, gender, suffix,
        syllable_count, syllable_class, ends_in_sibilant, phonological_condition.

    Notes
    -----
    For each genitive singular form, extracts:
    - Lemma
    - Genitive form
    - Genitive suffix (s vs es)
    - Syllable count of lemma
    - Whether stem ends in sibilant
    """
    rows: List[Dict[str, Union[str, int, bool]]] = []

    for item in data:
        features: List[str] = item['features']  # type: ignore[assignment]

        # Only process genitive singular forms
        if 'GEN' not in features or 'SG' not in features:
            continue

        # Only process nouns (masculine/neuter take -s/-es)
        gender: Optional[str] = None
        if 'MASC' in features:
            gender = 'MASC'
        elif 'NEUT' in features:
            gender = 'NEUT'
        elif 'FEM' in features:
            # Feminine nouns don't take -s/-es in genitive, skip
            continue

        if not gender:
            continue

        lemma: str = item['lemma']  # type: ignore[assignment]
        genitive: str = item['inflected_form']  # type: ignore[assignment]

        # Detect suffix
        suffix: Optional[str] = detect_genitive_suffix(lemma, genitive)

        if suffix in ['s', 'es']:
            syllables: int = count_syllables(lemma)
            ends_sibilant: bool = ends_in_sibilant(lemma)

            rows.append({
                'lemma': lemma,
                'genitive_form': genitive,
                'gender': gender,
                'suffix': suffix,
                'syllable_count': syllables,
                'syllable_class': 'monosyllabic' if syllables == 1 else 'polysyllabic',
                'ends_in_sibilant': ends_sibilant,
                'phonological_condition': 'sibilant' if ends_sibilant else ('monosyllabic' if syllables == 1 else 'polysyllabic')
            })

    return pd.DataFrame(rows)

def create_plural_suffix_dataset(data: List[Dict[str, Union[str, List[str]]]]) -> pd.DataFrame:
    """
    Create dataset for plural suffix analysis.

    Parameters
    ----------
    data : List[Dict[str, Union[str, List[str]]]]
        Parsed UniMorph data containing inflected forms and features.

    Returns
    -------
    pd.DataFrame
        DataFrame with columns: lemma, gender, singular_form, plural_form,
        plural_suffix, syllable_count.

    Notes
    -----
    For each noun lemma with plural forms, extracts:
    - Lemma
    - Gender
    - Plural form
    - Plural suffix type
    """
    # First, organize data by lemma
    lemma_data: Dict[str, LemmaInfo] = defaultdict(LemmaInfo)

    for item in data:
        features: List[str] = item['features']  # type: ignore[assignment]

        # Only process nouns
        if 'N' not in features:
            continue

        # Get gender
        gender: Optional[str] = None
        if 'MASC' in features:
            gender = 'MASC'
        elif 'FEM' in features:
            gender = 'FEM'
        elif 'NEUT' in features:
            gender = 'NEUT'

        if not gender:
            continue

        lemma: str = item['lemma']  # type: ignore[assignment]
        lemma_data[lemma]['gender'] = gender

        # Store singular form (nominative singular as base)
        if 'SG' in features and 'NOM' in features:
            lemma_data[lemma]['singular'] = item['inflected_form']

        # Store plural forms
        if 'PL' in features:
            plural_list: List[str] = lemma_data[lemma]['plural']  # type: ignore[assignment]
            plural_list.append(item['inflected_form'])  # type: ignore[arg-type]

    # Now create dataset
    rows: List[Dict[str, Union[str, int]]] = []

    for lemma, info in lemma_data.items():
        plural_forms: List[str] = info['plural']  # type: ignore[assignment]
        if info['gender'] and plural_forms:
            # Use the lemma itself as base form
            base_form: str = lemma

            # Take first plural form (usually nominative plural)
            plural_form: str = plural_forms[0]

            # Detect suffix
            suffix: str = detect_plural_suffix(base_form, plural_form)

            # Only include recognized suffixes
            if suffix in ['e', 'en', 'er', 's', 'ø']:
                rows.append({
                    'lemma': lemma,
                    'gender': info['gender'],  # type: ignore[dict-item]
                    'singular_form': base_form,
                    'plural_form': plural_form,
                    'plural_suffix': suffix,
                    'syllable_count': count_syllables(base_form)
                })

    return pd.DataFrame(rows)

def main() -> None:
    """Run the main data extraction pipeline."""
    print("Fetching UniMorph data...")

    # We'll use German as it has rich morphology with interesting patterns
    language: str = 'deu'  # German
    source_commit: str = "d226d2112d3490d8f04ece10d4538123d4297a39"
    url: str = (
        "https://raw.githubusercontent.com/unimorph/"
        f"{language}/{source_commit}/{language}"
    )
    output_directory: Path = Path(__file__).resolve().parent.parent / "data"
    output_directory.mkdir(parents=True, exist_ok=True)

    print(f"Parsing UniMorph {language} data...")
    data: List[Dict[str, Union[str, List[str]]]] = parse_unimorph_file(url)
    print(f"Loaded {len(data)} inflected forms")

    if not data:
        print("Error: No data loaded. Exiting.")
        return

    # Analyze feature distribution
    feature_counter: Counter[str] = Counter()
    for item in data:
        features: List[str] = item['features']  # type: ignore[assignment]
        for feature in features:
            feature_counter[feature] += 1

    print("\n=== Most Common Features ===")
    for feature, count in feature_counter.most_common(20):
        print(f"{feature}: {count}")

    # Dataset 1: Genitive Allomorphy (for Fisher's Exact Test)
    print("\n\n=== Creating Dataset 1: Genitive Allomorphy (-s vs -es) ===")
    df_genitive: pd.DataFrame = create_genitive_allomorphy_dataset(data)

    print(f"Created dataset with {len(df_genitive)} genitive forms")
    if len(df_genitive) > 0:
        print("\nSuffix distribution:")
        print(df_genitive['suffix'].value_counts())
        print("\nSyllable class distribution:")
        print(df_genitive['syllable_class'].value_counts())
        print("\nEnds in sibilant:")
        print(df_genitive['ends_in_sibilant'].value_counts())

        print("\n=== Syllable Class × Suffix Crosstab ===")
        print(pd.crosstab(df_genitive['syllable_class'], df_genitive['suffix']))

        print("\n=== Sibilant × Suffix Crosstab ===")
        print(pd.crosstab(df_genitive['ends_in_sibilant'], df_genitive['suffix']))

        # Save genitive dataset
        output_path_gen: Path = output_directory / 'unimorph_genitive.csv'
        df_genitive.to_csv(output_path_gen, index=False)
        print(f"\nGenitive dataset saved to {output_path_gen}")

        # Show examples
        print("\n=== Example Genitive Forms ===")
        print(df_genitive.head(10)[['lemma', 'genitive_form', 'suffix', 'syllable_count', 'ends_in_sibilant']].to_string(index=False))

    # Dataset 2: Plural Suffix Types (for Chi-Squared Test)
    print("\n\n=== Creating Dataset 2: Plural Suffix × Gender ===")
    df_plural: pd.DataFrame = create_plural_suffix_dataset(data)

    print(f"Created dataset with {len(df_plural)} plural forms")
    if len(df_plural) > 0:
        print("\nPlural suffix distribution:")
        print(df_plural['plural_suffix'].value_counts())
        print("\nGender distribution:")
        print(df_plural['gender'].value_counts())

        print("\n=== Gender × Plural Suffix Crosstab ===")
        crosstab: pd.DataFrame = pd.crosstab(df_plural['gender'], df_plural['plural_suffix'])
        print(crosstab)

        # Save plural dataset
        output_path_plural: Path = output_directory / 'unimorph_plural.csv'
        df_plural.to_csv(output_path_plural, index=False)
        print(f"\nPlural dataset saved to {output_path_plural}")

        # Show examples
        print("\n=== Example Plural Forms ===")
        for suffix in ['e', 'en', 'er', 's', 'ø']:
            examples: pd.DataFrame = df_plural[df_plural['plural_suffix'] == suffix].head(3)
            if len(examples) > 0:
                print(f"\n-{suffix} examples:")
                print(examples[['lemma', 'gender', 'singular_form', 'plural_form']].to_string(index=False))

    print("\n=== Data extraction complete ===")
    print("\nFiles created:")
    print(f"  - {output_directory / 'unimorph_genitive.csv'}")
    print(f"  - {output_directory / 'unimorph_plural.csv'}")

if __name__ == '__main__':
    main()
