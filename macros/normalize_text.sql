{% macro normalize_text(field) %}
    LOWER(TRIM({{ field }}))
{% endmacro %}