Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4335D322675
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 08:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhBWHio (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 02:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhBWHii (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 02:38:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4798264E3F;
        Tue, 23 Feb 2021 07:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614065877;
        bh=+afHJL7e/wCiWy1fR3SnBqcXl4qAUrsL6SV/cscUuS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CojkXMw+D4xi8Ti41V/VFR9Q1WVoX0hp7R75fovuDbPZcg+qj6u7m6YzpVYGC71HE
         jR5UecxyC6v/4qy07UXCqwmEw+GYkh6+kPzHRvw2URO6hT4EsIwcaFwPGr670/80nY
         kSssKQYG2EWbxJ6tnRTdRst/4u92kpzBmyovp5eTfaaPqipAJ5C4F8JwEr2I55KPIa
         BGoAxQIipcdnWHrZpuP+EtmYaolNQK1B3KdGGrkPx9e/BgBaTp8RW4/di+dSF8csBd
         4ZNHASZsdVu5K6siL04IqjJbpPet+nl1xTqZ6mXd2rHBT6EoDUk3Xg/eLROT2uztVr
         VnjH2YWHRoyyQ==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH] perf-probe: dso: Add symbols in .text.* subsections to text symbol map in kenrel modules
Date:   Tue, 23 Feb 2021 16:37:52 +0900
Message-Id: <161406587251.969784.5469149622544499077.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
References: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The kernel modules have .text.* subsections such as .text.unlikely.
Since dso__process_kernel_symbol() only identify the symbols in the ".text"
section as the text symbols and inserts it in the default dso in the map,
the symbols in such subsections can not be found by map__find_symbol().

This adds the symbols in those subsections to the default dso in the map so
that map__find_symbol() can find them. This solves the perf-probe issue on
probing online module.

Without this fix, probing on a symbol in .text.unlikely fails.
  ----
  # perf probe -m nf_conntrack nf_l4proto_log_invalid
  Probe point 'nf_l4proto_log_invalid' not found.
    Error: Failed to add events.
  ----

With this fix, it works because map__find_symbol() can find the symbol
correctly.
  ----
  # perf probe -m nf_conntrack nf_l4proto_log_invalid
  Added new event:
    probe:nf_l4proto_log_invalid (on nf_l4proto_log_invalid in nf_conntrack)

  You can now use it in all perf tools, such as:

  	perf record -e probe:nf_l4proto_log_invalid -aR sleep 1

  ----

Reported-by: Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 tools/perf/util/symbol-elf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 6dff843fd883..0c1113236913 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -985,7 +985,9 @@ static int dso__process_kernel_symbol(struct dso *dso, struct map *map,
 	if (strcmp(section_name, (curr_dso->short_name + dso->short_name_len)) == 0)
 		return 0;
 
-	if (strcmp(section_name, ".text") == 0) {
+	/* .text and .text.* are included in the text dso */
+	if (strncmp(section_name, ".text", 5) == 0 &&
+	    (section_name[5] == '\0' || section_name[5] == '.')) {
 		/*
 		 * The initial kernel mapping is based on
 		 * kallsyms and identity maps.  Overwrite it to

