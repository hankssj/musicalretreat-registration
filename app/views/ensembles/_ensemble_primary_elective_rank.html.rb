<li> Elective: <%= Elective.find(ensemble_primary_elective_rank.elective_id).name %>
     Instrument <%= ensemble_primary_elective_rank.instrument_id ? Instrument.find(ensemble_primary_elective_rank.instrument_id).display_name : "none" %>
     Rank <%= ensemble_primary_elective_rank.rank %>
</li>
