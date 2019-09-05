Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7120EAA36D
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbfIEMpV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 08:45:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:40694 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731301AbfIEMpS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 08:45:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4742B0BA;
        Thu,  5 Sep 2019 12:45:17 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, nstange@suse.de,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [RFC PATCH v2 3/3] livepatch: Clean up klp_update_object_relocations() return paths
Date:   Thu,  5 Sep 2019 14:45:14 +0200
Message-Id: <20190905124514.8944-4-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190905124514.8944-1-mbenes@suse.cz>
References: <20190905124514.8944-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/livepatch/core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 023c9333c276..73ddddd5add5 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -251,7 +251,7 @@ static int klp_update_object_relocations(struct module *pmod,
 					 struct klp_object *obj,
 					 reloc_update_fn_t reloc_update_fn)
 {
-	int i, cnt, ret = 0;
+	int i, cnt, ret;
 	const char *objname, *secname;
 	char sec_objname[MODULE_NAME_LEN];
 	Elf_Shdr *sec;
@@ -277,8 +277,7 @@ static int klp_update_object_relocations(struct module *pmod,
 		if (cnt != 1) {
 			pr_err("section %s has an incorrectly formatted name\n",
 			       secname);
-			ret = -EINVAL;
-			break;
+			return -EINVAL;
 		}
 
 		if (strcmp(objname, sec_objname))
@@ -286,10 +285,10 @@ static int klp_update_object_relocations(struct module *pmod,
 
 		ret = reloc_update_fn(pmod, i);
 		if (ret)
-			break;
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
2.23.0

