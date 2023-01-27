Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565C867DDD9
	for <lists+live-patching@lfdr.de>; Fri, 27 Jan 2023 07:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbjA0Gkn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Jan 2023 01:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjA0GkU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Jan 2023 01:40:20 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BE66ACAC;
        Thu, 26 Jan 2023 22:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wPxHhaRZN6bt7mo7Kmz71jMB8x1VOFtn9vL42DR9a2U=; b=mxoBxwohg4yqbWOJFYXx9b38gY
        2kpxaQnim1yFeQhuR37mzgEhVicw93WcVMGpE29U8PXTxoGYm+FSR1Qp17bIRdGHUa7I/OQXwBfw8
        iaadcRpEztqFTMt9PUh+UW2Nsdu/sqpiFdYKo31PD1I2EqOvwPu/Z1/eftpBjdTrzHctFF76R+/Fg
        bCdYR/BxI9BzUIxF4HELxso7Mjbv0xwkZtgDNUkdLdrXBQniHHTDa7m0+/PbK6rmQKUvGrczUO55S
        joHevykAF6jEKDldEa6t931njbF2/gAHOLv4A57+5hgR3kt9jMXrk0RipnSef1lAeLFAcb1QatQf1
        PIwyZPXw==;
Received: from [2601:1c2:d80:3110::9307] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pLIPJ-00DM0u-GF; Fri, 27 Jan 2023 06:40:17 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 16/35] Documentation: livepatch: correct spelling
Date:   Thu, 26 Jan 2023 22:39:46 -0800
Message-Id: <20230127064005.1558-17-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127064005.1558-1-rdunlap@infradead.org>
References: <20230127064005.1558-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Correct spelling problems for Documentation/livepatch/ as reported
by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: live-patching@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/livepatch/reliable-stacktrace.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/Documentation/livepatch/reliable-stacktrace.rst b/Documentation/livepatch/reliable-stacktrace.rst
--- a/Documentation/livepatch/reliable-stacktrace.rst
+++ b/Documentation/livepatch/reliable-stacktrace.rst
@@ -40,7 +40,7 @@ Principally, the reliable stacktrace fun
 .. note::
    In some cases it is legitimate to omit specific functions from the trace,
    but all other functions must be reported. These cases are described in
-   futher detail below.
+   further detail below.
 
 Secondly, the reliable stacktrace function must be robust to cases where
 the stack or other unwind state is corrupt or otherwise unreliable. The
