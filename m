Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485BA140D59
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgAQPEn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:46254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729133AbgAQPEB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5D7BEBB77;
        Fri, 17 Jan 2020 15:04:00 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 14/23] livepatch: Never block livepatch modules when the related module is being removed
Date:   Fri, 17 Jan 2020 16:03:14 +0100
Message-Id: <20200117150323.21801-15-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Originally, it was not possible to remove the single livepatch module when
the code was used during a forced transition. There were no guarantees that
the code was no longer used.

Even the split livepatch modules have to stay when the entire livepatch
gets disabled/replaced and the livepatch modules were used during
a forced transition.

On the other hand, klp_module_going() callback is called when the patched
module is about to be removed. It's code should no longer be used.
The same should be true also for the related livepatch module. Therefore
the livepatch module could always get removed as well.

It allows to load the patched module again in the future. Otherwise,
it would get blocked because the related livepatch module could not
get loaded more times.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 73462b66f63f..4b55d805f3ec 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1391,6 +1391,13 @@ void klp_module_going(struct module *mod)
 	klp_for_each_patch(patch) {
 		klp_for_each_object_safe(patch, obj, tmp_obj) {
 			if (obj->name && !strcmp(obj->name, mod->name)) {
+				/*
+				 * The livepatched module is about to be
+				 * destroyed. It's code is no longer used.
+				 * Same is true for the livepatch even when
+				 * it was part of forced transition.
+				 */
+				obj->forced = false;
 				klp_remove_object(obj);
 			}
 		}
-- 
2.16.4

