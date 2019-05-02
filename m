Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BEB111A3
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 04:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEBCkO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 22:40:14 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:35033 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726403AbfEBCkA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 22:40:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4C288602;
        Wed,  1 May 2019 22:32:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 May 2019 22:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=T9nKSChfea+oLMY5Kpw3eMK6igS+zn5o65ZT0pR8nNs=; b=3IsP2xoj
        pcneIPGwZYM2nu7GBCgzNfeZJQxD7gTFVLqWqbNYdsFy5lGAt0j+Yftmhm37wCtO
        olS+we/4bFLZUXU/03houOPuS2myw5US81M5yBTV5MkgOQ0CNErciyJedNXK+ni0
        u2cOvKWfvXO7ED6Eqken56FRXurUl8wDT+7aVx6yzQCH+jRUrn6qcnyQ3W1Tv64j
        dCpWKG9W52JWaGvxm4wkR3P8eoZGKTbN0xGex/Khq1snMeQrX7KqJM2bvITDuibX
        NOyyh2zl+LXM8xy8wu5JQjX7kts1qM4tnO1Pn90b1gciQgUlfomdMCmFyk/SbJtT
        v13oTN1Lln+vdg==
X-ME-Sender: <xms:xlbKXJR6uF5rUak898Rvo-aujCJFAwDXwwnrMvYqvByX74fFonjccA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:xlbKXOJbCgjvxAtCN-K2iKlFjLMA69TN5wIvvL_7v8xFA4jJZklNVA>
    <xmx:xlbKXMkttnrWxbhNZ_4RtFeGNM0NXWwYxKot8IVCWAjJBzG_Ut2oig>
    <xmx:xlbKXHhLLz4GQR0rve3FRnIrbHKLVpaOSVKou9Vi7t6-5sX0_JU2qw>
    <xmx:xlbKXGNLj8t60Gv9s9HQXHrVbwC8_eJNsmaaGcyNyv47noDZ1JAr4w>
Received: from eros.localdomain (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D226E407B;
        Wed,  1 May 2019 22:32:35 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/5] kobject: Remove docstring reference to kset
Date:   Thu,  2 May 2019 12:31:39 +1000
Message-Id: <20190502023142.20139-3-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502023142.20139-1-tobin@kernel.org>
References: <20190502023142.20139-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently the docstring for kobject_get_path() mentions 'kset'.  The
kset is not used in the function callchain starting from this function.

Remove docstring reference to kset from the function kobject_get_path().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/kobject.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index aa89edcd2b63..3eacd5b4643f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -153,12 +153,11 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
 }
 
 /**
- * kobject_get_path - generate and return the path associated with a given kobj and kset pair.
- *
+ * kobject_get_path() - Allocate memory and fill in the path for @kobj.
  * @kobj:	kobject in question, with which to build the path
  * @gfp_mask:	the allocation type used to allocate the path
  *
- * The result must be freed by the caller with kfree().
+ * Return: The newly allocated memory, caller must free with kfree().
  */
 char *kobject_get_path(struct kobject *kobj, gfp_t gfp_mask)
 {
-- 
2.21.0

