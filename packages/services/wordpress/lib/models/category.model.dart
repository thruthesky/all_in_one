class WPCategory {
  WPCategory({
    required this.termId,
    required this.name,
    required this.slug,
    required this.termGroup,
    required this.termTaxonomyId,
    required this.taxonomy,
    required this.description,
    required this.parent,
    required this.count,
    required this.filter,
    required this.depth,
  });

  final int termId;
  final String name;
  final String slug;
  final int termGroup;
  final int termTaxonomyId;
  final String taxonomy;
  final String description;
  final int parent;
  final int count;
  final String filter;
  final int depth;

  factory WPCategory.fromJson(Map<String, dynamic> json) => WPCategory(
        termId: json["term_id"],
        name: json["name"],
        slug: json["slug"],
        termGroup: json["term_group"],
        termTaxonomyId: json["term_taxonomy_id"],
        taxonomy: json["taxonomy"],
        description: json["description"],
        parent: json["parent"],
        count: json["count"],
        filter: json["filter"],
        depth: json["depth"],
      );

  Map<String, dynamic> toJson() => {
        "term_id": termId,
        "name": name,
        "slug": slug,
        "term_group": termGroup,
        "term_taxonomy_id": termTaxonomyId,
        "taxonomy": taxonomy,
        "description": description,
        "parent": parent,
        "count": count,
        "filter": filter,
        "depth": depth,
      };
}
