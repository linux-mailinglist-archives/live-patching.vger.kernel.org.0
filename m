Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F8C30BDDD
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 13:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBBMOw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 07:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhBBMOl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 07:14:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97303C061786;
        Tue,  2 Feb 2021 04:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=x0ild1pWjAVS3WJxvq5XS64FoqpcDSC4Uujd61u50FE=; b=srM/EzIfbz/5riWYH6qumnb+zn
        j+mvi5gYrNB+AOYu3bH2i/2M1fx63vsCsf2YIiEVvlyENL+ojTgqwGXMJUGdqwp4OEMWQ4aObiZ3H
        B+0koplMVj7VdqGLo6QxINw2K1pPISxF+kTMN0mNirghPTmZYC8RLKeCQ/OCR8Ff7Rqv5Be4TQVuK
        M5qKT5l3HuJyH04i8EHBxJh98XWMNEPc+qGqhCjgDNrLd36g6Ug04LWZyNF/qW+Hj7Vqx9COZL6rr
        jFQnwP7EDOpAKJHGVY2nr8FtSMZvZlG3rLoxmOxEMmdSrfWNwf6Xks/iXNj+HglObnNEjoXvCOzCs
        PaXZle4w==;
Received: from [2001:4bb8:198:6bf4:7f38:755e:a6e0:73e9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6uYq-00FAKY-Ez; Tue, 02 Feb 2021 12:13:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: module loader dead code removal and cleanups v3
Date:   Tue,  2 Feb 2021 13:13:21 +0100
Message-Id: <20210202121334.1361503-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi all,

this series removes support for long term unused export types and
cleans up various loose ends in the module loader.

Changes since v2:
 - clean up klp_find_object_symbol a bit
 - remove the now unused module_assert_mutex helper 

Changes since v1:
 - move struct symsearch to module.c
 - rework drm to not call find_module at all
 - allow RCU-sched locking for find_module
 - keep find_module as a public API instead of module_loaded
 - update a few comments and commit logs

Diffstat:
