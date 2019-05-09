Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8884718C0D
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfEIOj3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfEIOjS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:18 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5706B3079B74;
        Thu,  9 May 2019 14:39:18 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 622755ED22;
        Thu,  9 May 2019 14:39:16 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 10/10] livepatch/klp-convert: abort on special sections
Date:   Thu,  9 May 2019 10:38:59 -0400
Message-Id: <20190509143859.9050-11-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 09 May 2019 14:39:18 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

To properly convert alternatives, paravirt ops, and static keys,
klp-convert needs to implement "klp.arch" sections as supported by
d4c3e6e1b193 (“livepatch/x86: apply alternatives and paravirt patches
after relocations”).

There is some amount of ELF section bookkeeping required for this (ie,
moving data structure entries and relocations to their ".klp.arch"
equivalents) but the hardest part will be determining klp_object
relationships.  This may require some larger changes to livepatch API,
so defer support for now.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-convert.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/livepatch/klp-convert.c b/scripts/livepatch/klp-convert.c
index 72b65428e738..b5873abecefb 100644
--- a/scripts/livepatch/klp-convert.c
+++ b/scripts/livepatch/klp-convert.c
@@ -617,6 +617,18 @@ static void free_converted_resources(struct elf *klp_elf)
 	}
 }
 
+/* Check for special sections that klp-convert doesn't support */
+static bool is_section_supported(char *sname)
+{
+	if (strcmp(sname, ".rela.altinstructions") == 0)
+		return false;
+	if (strcmp(sname, ".rela.parainstructions") == 0)
+		return false;
+	if (strcmp(sname, ".rela__jump_table") == 0)
+		return false;
+	return true;
+}
+
 int main(int argc, const char **argv)
 {
 	const char *klp_in_module, *klp_out_module, *symbols_list;
@@ -649,6 +661,12 @@ int main(int argc, const char **argv)
 	}
 
 	list_for_each_entry_safe(sec, aux, &klp_elf->sections, list) {
+		if (!is_section_supported(sec->name)) {
+			WARN("Special ELF section: %s not supported",
+				sec->name);
+			return -1;
+		}
+
 		if (!is_rela_section(sec) ||
 		    is_klp_rela_section(sec->name))
 			continue;
-- 
2.20.1

