FROM trinodb/trino:354

USER root

# ADD entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

USER trino:trino

# ENTRYPOINT [ "/entrypoint.sh"]
CMD ["/usr/lib/trino/bin/run-trino"]