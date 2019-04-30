Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808C1ED97
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 02:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfD3AQ0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 20:16:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41101 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729661AbfD3AQZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 20:16:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8FA9F2201F;
        Mon, 29 Apr 2019 20:16:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Apr 2019 20:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0O9SAkEGxogfnobPq0czxzKl2mDOpLSVqbenVGSTf9I=; b=yrCKg7ic
        SjsSFDI8oLQZFDI/l1G7VOjJ3VcgGyvIrcLRWqkG8X4TxjT1eOwfFHPkE/6XbSBi
        TwUUEYR15BTthF9zX0x9JNd6iEDukjulcAaoDcMZ3v6I3ats6h3c05E+xqdeR72b
        W10R0osSgyyVTwbO+vYooBx4NsPZyfBP+IQKbm0r407zBE9iF24HNc5ZP+lR1ypg
        13I7kDrOldWEueU0Hc7hxpeM4dSQoAG6aEoSJxdZZf24+Ck29tXYCFIokplS5q9i
        v7QlSaD4u2NPY7OV319h4h6K6TE9loXr96GsMdbbq1/WNCDZC0mpCTig0KceKm7P
        hiBZi5PI5WSB6A==
X-ME-Sender: <xms:2JPHXLn6JFdPs5zsqbvvUAe2SLbPmBjtjKBOQl7MiE8IMNbaLjfTvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvfedtrddukeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:2JPHXD2mHgbhwSWDnpVrrDwutgFPGXwsP40PkWSKftl2PHEayL6dRw>
    <xmx:2JPHXMjgHGQMF-jjPq-b5nSC24UN-rHjHp3nlNwXfFbgQ6kFP-NfYg>
    <xmx:2JPHXH2pngIZJjuSVcvqqRnMo49k9roZGg9c-13uAU9lzjWLPiHEkg>
    <xmx:2JPHXMrEcafZleuKGFwk1Ixo0arLSOVtqEy0JI9f0wLnAOaUHtkAgQ>
Received: from eros.localdomain (ppp121-44-230-188.bras2.syd2.internode.on.net [121.44.230.188])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60DD8103CC;
        Mon, 29 Apr 2019 20:16:21 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] livepatch: Fix kobject memleak
Date:   Tue, 30 Apr 2019 10:15:33 +1000
Message-Id: <20190430001534.26246-2-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430001534.26246-1-tobin@kernel.org>
References: <20190430001534.26246-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently error return from kobject_init_and_add() is not followed by a
call to kobject_put().  This means there is a memory leak.

Add call to kobject_put() in error path of kobject_init_and_add().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 kernel/livepatch/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index eb0ee10a1981..98a7bec41faa 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -727,7 +727,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
 				   &obj->kobj, "%s,%lu", func->old_name,
 				   func->old_sympos ? func->old_sympos : 1);
-	if (!ret)
+	if (ret)
+		kobject_put(&func->kobj);
+	else
 		func->kobj_added = true;
 
 	return ret;
@@ -803,8 +805,10 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 	name = klp_is_module(obj) ? obj->name : "vmlinux";
 	ret = kobject_init_and_add(&obj->kobj, &klp_ktype_object,
 				   &patch->kobj, "%s", name);
-	if (ret)
+	if (ret) {
+		kobject_put(&func->kobj);
 		return ret;
+	}
 	obj->kobj_added = true;
 
 	klp_for_each_func(obj, func) {
@@ -862,8 +866,10 @@ static int klp_init_patch(struct klp_patch *patch)
 
 	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
 				   klp_root_kobj, "%s", patch->mod->name);
-	if (ret)
+	if (ret) {
+		kobject_put(&func->kobj);
 		return ret;
+	}
 	patch->kobj_added = true;
 
 	if (patch->replace) {
-- 
2.21.0

