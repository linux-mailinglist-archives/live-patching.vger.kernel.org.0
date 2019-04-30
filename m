Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FEAED96
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 02:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfD3AQa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 20:16:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34997 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729063AbfD3AQ3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 20:16:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8A82422033;
        Mon, 29 Apr 2019 20:16:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Apr 2019 20:16:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3hpyoEIDzQWdYfgBuq1Ugk9Fr9Uz/MdTRcHxzF5iQuk=; b=4JUaft5R
        LI5je63wEYXgMy3VoM+hbMnXGdTn9KuZr57T0CnZDuIKIDgYfNcgy17bxyAkGPDF
        zCvKUfPfq2iLt+e1dh4o8k5JrB4e9lzdEZl8B8QLcRVwml6B2owXBZUBstTJqAem
        xUfwK+O9lJxCj2TnkHS+NHy/EL0UNjW5dCTAWXs/idPEq1WdsCf/oEd+IytQiXcx
        n770XCS17Wbpj2Ee4xkXYK3E+Fh77jsDcREhTH5rt2+DtrhSXkSFh4dvDKe8Rmd8
        oPSC7sTnycDGJxwW8wjTszxIFudwst/0RGiDiz2lcOg9V08E1ijwURO8r8YDef5X
        hUlWtmIa7WKP8w==
X-ME-Sender: <xms:3JPHXN3r9Pn4hqTbAs_YV3PAn2qBU9O8ChBpf-6gcpfc4pxLwcYUHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvfedtrddukeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3JPHXIXwETBX0LjZlNMuMnLDpl_sZn-iaY-QgnKqYG0_tX4t86xMdA>
    <xmx:3JPHXI7TAWioI3ISjYBFosa2A6l9SmVAnl9cf7uNndzy7ut5MVGUFQ>
    <xmx:3JPHXPKwvyajlrGS6hHFIEcMeMy4HfF4oCgdvZN7ifseOYnTOQa67w>
    <xmx:3JPHXKlS0zHElkO6r8tnSPeZCe-TRo-4yMr0ucbTC61YAqLJkJdkPg>
Received: from eros.localdomain (ppp121-44-230-188.bras2.syd2.internode.on.net [121.44.230.188])
        by mail.messagingengine.com (Postfix) with ESMTPA id 510CC1037C;
        Mon, 29 Apr 2019 20:16:25 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] livepatch: Use correct kobject cleanup function
Date:   Tue, 30 Apr 2019 10:15:34 +1000
Message-Id: <20190430001534.26246-3-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430001534.26246-1-tobin@kernel.org>
References: <20190430001534.26246-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The correct cleanup function after a call to kobject_init_and_add() has
succeeded is kobject_del() _not_ kobject_put().  kobject_del() calls
kobject_put().

Use correct cleanup function when removing a kobject.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 kernel/livepatch/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 98a7bec41faa..4cce6bb6e073 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -589,9 +589,8 @@ static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
 
 		list_del(&func->node);
 
-		/* Might be called from klp_init_patch() error path. */
 		if (func->kobj_added) {
-			kobject_put(&func->kobj);
+			kobject_del(&func->kobj);
 		} else if (func->nop) {
 			klp_free_func_nop(func);
 		}
@@ -625,9 +624,8 @@ static void __klp_free_objects(struct klp_patch *patch, bool nops_only)
 
 		list_del(&obj->node);
 
-		/* Might be called from klp_init_patch() error path. */
 		if (obj->kobj_added) {
-			kobject_put(&obj->kobj);
+			kobject_del(&obj->kobj);
 		} else if (obj->dynamic) {
 			klp_free_object_dynamic(obj);
 		}
@@ -676,7 +674,7 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	 * cannot get enabled again.
 	 */
 	if (patch->kobj_added) {
-		kobject_put(&patch->kobj);
+		kobject_del(&patch->kobj);
 		wait_for_completion(&patch->finish);
 	}
 
-- 
2.21.0

