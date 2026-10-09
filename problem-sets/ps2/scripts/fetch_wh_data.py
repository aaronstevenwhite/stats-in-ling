#!/usr/bin/env python3
"""Extract annotations for WH expressions from UD English EWT.

For each token identified by its form, lemma, or UD ``PronType`` feature as a
WH expression, the script records the token's basic syntactic head and
dependency relation. It also records several descriptive properties of that
dependency. The PS2 preparation script subsequently selects ``what``,
``which``, and ``who`` tokens annotated as ``nsubj`` or ``obj``.

The syntactic head recorded here is not assumed to be a filler gap. The
assignment analyzes the UD relation annotated on the WH token itself.

Notes
-----
**Computed Metrics:**

1. **Linear Distance**: Absolute token position difference between a WH token and
   its syntactic head.

   Example: "What did you eat?"
       - Positions: What(1) did(2) you(3) eat(4)
       - "What" has head "eat" at position 4
       - Linear distance = |4 - 1| = 3 tokens

2. **Dependency Type**: Grammatical relation (deprel) label such as nsubj, obj,
   obl, advmod indicating the syntactic function.

3. **Enhanced Dependencies**: Additional dependency relations from the DEPS
   column in CoNLL-U format, capturing non-tree relations.

4. **Intervening Clause Indicators**: Count of clause-related dependency
   labels between the WH token and its basic syntactic head.
   Identified by relations: mark, advcl, acl:relcl, ccomp, xcomp.

**WH-words Detected:**
    - Interrogatives: what, who, whom, which, where, when, why, how, whose
    - Extended forms: whatever, whoever, whichever, etc.
    - Also uses PronType=Int and PronType=Rel features from morphology

Examples
--------
Run the script to extract WH-dependencies and create CSV file::

    $ python fetch_wh_data.py

The output file is created in the assignment's ``data`` directory:
    - ud_wh_dependencies_raw.csv

The output includes columns for the sentence, WH token, syntactic head,
dependency relation, and descriptive distances.

See Also
--------
Universal Dependencies: https://universaldependencies.org/
UD English-EWT: https://github.com/UniversalDependencies/UD_English-EWT
Pinned source revision: 4a4d77f599ea53cc405f85d0cec4b2f14f81d42b
"""

from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple, Union
from urllib.request import urlopen

import pandas as pd


# Type definitions for CoNLL-U parsing
Token = Dict[str, Union[int, str]]
Sentence = Dict[str, Union[str, List[Token]]]


def parse_conllu(url: str) -> List[Sentence]:
    """
    Parse CoNLL-U format from URL and return sentences as list of dicts.

    Parameters
    ----------
    url : str
        URL to the CoNLL-U formatted file.

    Returns
    -------
    List[Sentence]
        List of sentences, each containing 'text' and 'tokens' keys.
    """
    sentences: List[Sentence] = []
    current_sentence: List[Token] = []
    sentence_text: str = ""

    with urlopen(url) as response:
        for line in response:
            line_str: str = line.decode('utf-8').strip()

            # Extract sentence text from comment
            if line_str.startswith('# text = '):
                sentence_text = line_str[9:]

            # Skip other comments and empty lines between sentences
            if not line_str or line_str.startswith('#'):
                if current_sentence and not line_str:
                    sentences.append({
                        'text': sentence_text,
                        'tokens': current_sentence
                    })
                    current_sentence = []
                    sentence_text = ""
                continue

            # Parse token line
            fields: List[str] = line_str.split('\t')
            if len(fields) == 10:
                # Skip multi-word tokens (e.g., 1-2)
                if '-' in fields[0] or '.' in fields[0]:
                    continue

                token: Token = {
                    'id': int(fields[0]),
                    'form': fields[1],
                    'lemma': fields[2],
                    'upos': fields[3],
                    'xpos': fields[4],
                    'feats': fields[5],
                    'head': int(fields[6]) if fields[6] != '_' else 0,
                    'deprel': fields[7],
                    'deps': fields[8],
                    'misc': fields[9]
                }
                current_sentence.append(token)

    # Add last sentence if exists
    if current_sentence:
        sentences.append({
            'text': sentence_text,
            'tokens': current_sentence
        })

    return sentences

def count_intervening_clauses(tokens: List[Token], start_pos: int, end_pos: int) -> int:
    """
    Count clause boundaries between start and end positions.

    Parameters
    ----------
    tokens : List[Token]
        List of token dictionaries from a sentence.
    start_pos : int
        Starting token position.
    end_pos : int
        Ending token position.

    Returns
    -------
    int
        Count of clause-introducing tokens in the span.

    Notes
    -----
    We identify clause boundaries by looking for:
    - Subordinating conjunctions (deprel='mark')
    - Adverbial clauses (deprel='advcl')
    - Relative clauses (deprel='acl:relcl')
    - Complement clauses (deprel='ccomp', 'xcomp')
    """
    min_pos: int = min(start_pos, end_pos)
    max_pos: int = max(start_pos, end_pos)

    clause_markers: Set[str] = {'mark', 'advcl', 'acl:relcl', 'ccomp', 'xcomp', 'acl'}

    count: int = 0
    for token in tokens:
        token_id: int = token['id']  # type: ignore[assignment]
        # Check if token is within the span
        if min_pos < token_id < max_pos:
            token_deprel: str = token['deprel']  # type: ignore[assignment]
            # Check if it marks a clause boundary
            if any(marker in token_deprel for marker in clause_markers):
                count += 1

    return count

def parse_enhanced_deps(deps_string: str) -> List[Tuple[int, str]]:
    """
    Parse enhanced dependencies from DEPS column.

    Parameters
    ----------
    deps_string : str
        Enhanced dependencies string from CoNLL-U DEPS column.

    Returns
    -------
    List[Tuple[int, str]]
        List of (head_id, relation) tuples.

    Notes
    -----
    Format: "4:nsubj|5:obj" means this token is nsubj of 4 and obj of 5
    """
    if deps_string == '_' or not deps_string:
        return []

    enhanced: List[Tuple[int, str]] = []
    for dep in deps_string.split('|'):
        if ':' in dep:
            parts: List[str] = dep.split(':', 1)
            try:
                head_id: int = int(parts[0])
                relation: str = parts[1]
                enhanced.append((head_id, relation))
            except (ValueError, IndexError):
                continue

    return enhanced

def extract_wh_dependencies(sentences: List[Sentence]) -> pd.DataFrame:
    """
    Extract WH-word dependencies with comprehensive information.

    Parameters
    ----------
    sentences : List[Sentence]
        List of parsed sentences with tokens.

    Returns
    -------
    pd.DataFrame
        DataFrame containing WH-token dependency annotations.

    Notes
    -----
    For each WH-word, computes:
    - Linear distance to syntactic head
    - Dependency relation type
    - Enhanced dependency information
    - Intervening clause boundaries
    """
    # Expanded WH-word list to catch all interrogatives/relatives
    wh_words: Set[str] = {
        'what', 'who', 'whom', 'which', 'where', 'when', 'why', 'how', 'whose',
        'whatever', 'whoever', 'whomever', 'whichever', 'wherever', 'whenever', 'however'
    }

    data: List[Dict[str, Union[int, str]]] = []

    for sent_idx, sentence in enumerate(sentences):
        tokens: List[Token] = sentence['tokens']  # type: ignore[assignment]

        for token in tokens:
            token_lemma: str = token['lemma']  # type: ignore[assignment]
            token_form: str = token['form']  # type: ignore[assignment]
            # Check if token is a WH-word (by lemma or form)
            is_wh: bool = (token_lemma.lower() in wh_words or
                    token_form.lower() in wh_words)

            # Also check for PronType=Int or PronType=Rel in features
            has_wh_feature: bool = False
            token_feats: str = token['feats']  # type: ignore[assignment]
            if token_feats != '_':
                has_wh_feature = 'PronType=Int' in token_feats or 'PronType=Rel' in token_feats

            if is_wh or has_wh_feature:
                token_head: int = token['head']  # type: ignore[assignment]
                token_id: int = token['id']  # type: ignore[assignment]
                # Process basic dependency
                if token_head > 0:  # Has a head
                    # Calculate linear distance
                    distance: int = abs(token_head - token_id)

                    # Find the head token
                    head_token: Optional[Token] = next((t for t in tokens if t['id'] == token_head), None)

                    if head_token:  # Include all dependencies, even distance=0
                        # Count intervening clause boundaries
                        num_clauses: int = count_intervening_clauses(tokens, token_id, token_head)

                        # Parse enhanced dependencies
                        token_deps: str = token['deps']  # type: ignore[assignment]
                        enhanced_deps: List[Tuple[int, str]] = parse_enhanced_deps(token_deps)
                        enhanced_deps_str: str = ';'.join([f"{h}:{r}" for h, r in enhanced_deps]) if enhanced_deps else 'NONE'

                        # Determine direction
                        direction: str = 'forward' if token_head > token_id else 'backward'

                        token_deprel: str = token['deprel']  # type: ignore[assignment]
                        data.append({
                            'sentence_id': sent_idx,
                            'sentence_text': sentence['text'],  # type: ignore[dict-item]
                            'wh_word': token_form,
                            'wh_lemma': token_lemma,
                            'wh_pos': token['upos'],  # type: ignore[dict-item]
                            'wh_feats': token_feats,
                            'wh_position': token_id,
                            'head_position': token_head,
                            'head_word': head_token['form'],  # type: ignore[dict-item]
                            'head_lemma': head_token['lemma'],  # type: ignore[dict-item]
                            'head_pos': head_token['upos'],  # type: ignore[dict-item]
                            'linear_distance': distance,
                            'deprel': token_deprel,
                            'deprel_subtype': token_deprel.split(':')[-1] if ':' in token_deprel else 'NONE',
                            'enhanced_deps': enhanced_deps_str,
                            'num_enhanced_deps': len(enhanced_deps),
                            'intervening_clauses': num_clauses,
                            'direction': direction
                        })

    return pd.DataFrame(data)

def main() -> None:
    """Run the WH-dependency extraction pipeline."""
    print("Fetching Universal Dependencies English-EWT corpus...")
    source_commit: str = "4a4d77f599ea53cc405f85d0cec4b2f14f81d42b"
    ud_ewt_url: str = (
        "https://raw.githubusercontent.com/UniversalDependencies/"
        f"UD_English-EWT/{source_commit}/en_ewt-ud-train.conllu"
    )

    print("Parsing CoNLL-U format...")
    sentences: List[Sentence] = parse_conllu(ud_ewt_url)
    print(f"Found {len(sentences)} sentences")

    print("Extracting WH-token dependencies...")
    wh_data: pd.DataFrame = extract_wh_dependencies(sentences)
    print(f"Found {len(wh_data)} WH-token dependencies")

    # Save to CSV
    output_path: Path = (
        Path(__file__).resolve().parent.parent /
        "data" /
        "ud_wh_dependencies_raw.csv"
    )
    output_path.parent.mkdir(parents=True, exist_ok=True)
    wh_data.to_csv(output_path, index=False)
    print(f"\nData saved to {output_path}")

    # Print summary statistics
    print("\n=== Summary Statistics ===")
    print(f"Total WH-dependencies: {len(wh_data)}")
    print("\nWH-words distribution:")
    print(wh_data['wh_lemma'].value_counts().to_string())
    print("\nDependency relation distribution:")
    print(wh_data['deprel'].value_counts().head(10).to_string())
    print("\nLinear distance statistics:")
    print(wh_data['linear_distance'].describe().to_string())
    print("\nIntervening clauses statistics:")
    print(wh_data['intervening_clauses'].describe().to_string())
    print("\nDirection:")
    print(wh_data['direction'].value_counts().to_string())
    print("\nEnhanced dependencies available:")
    print((wh_data['enhanced_deps'] != 'NONE').value_counts().to_string())

    # Show a few examples
    print("\n=== Example Dependencies ===")
    for _, row in wh_data.head(5).iterrows():
        print(f"\n{row['sentence_text']}")
        print(f"  WH: '{row['wh_word']}' (pos {row['wh_position']}) -> head '{row['head_word']}' (pos {row['head_position']})")
        print(f"  Linear distance: {row['linear_distance']}, Direction: {row['direction']}")
        print(f"  Relation: {row['deprel']}, Intervening clauses: {row['intervening_clauses']}")
        enhanced_deps_val: str = row['enhanced_deps']  # type: ignore[assignment]
        if enhanced_deps_val != 'NONE':
            print(f"  Enhanced deps: {enhanced_deps_val}")

if __name__ == '__main__':
    main()
