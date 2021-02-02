Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214A530C214
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 15:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhBBOjj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 09:39:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhBBOhw (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 09:37:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EA0E64DD8;
        Tue,  2 Feb 2021 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612276631;
        bh=59H/RX/aCpZDci3/j2ROapoK3LntvgnOkKqeLSBExoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BY/9D9WwHzXHV3rnrsxuU0DcQz++ZS4+zEjOPjc9/OVHJHNkD9pRrAGxWG86yct89
         spsDRQsLsmBukU8bUtWzDGqSf1UHtMXlOsyar1BYxqiKJGZUHOsFdPkf11uSIFH9Qr
         IUNDnpAXy7GDi69hndOCbrrQE4yQIfVKdma3R4CjrfITUh+D+4avYXaNLvWGTR4wDn
         3SaOQkpanaLTh8gQv97wPm9/HzQpzKi/b2O8G8duzYuArEHa4Td8c/jklXhu2NcE9e
         B8E7acIz+20H5HXDUSnWEx2f5jizrmOSJ11Exuk00iCVeOGUDBySpAYWwd2oTQKxuj
         AITUddLLhFuPw==
Date:   Tue, 2 Feb 2021 15:37:04 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: module loader dead code removal and cleanups v3
Message-ID: <YBljkDgMFcqKcH8H@gunter>
References: <20210202121334.1361503-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210202121334.1361503-1-hch@lst.de>
X-OS:   Linux gunter 5.10.9-1-default x86_64
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Christoph Hellwig [02/02/21 13:13 +0100]:
>Hi all,
>
>this series removes support for long term unused export types and
>cleans up various loose ends in the module loader.
>
>Changes since v2:
> - clean up klp_find_object_symbol a bit
> - remove the now unused module_assert_mutex helper
>
>Changes since v1:
> - move struct symsearch to module.c
> - rework drm to not call find_module at all
> - allow RCU-sched locking for find_module
> - keep find_module as a public API instead of module_loaded
> - update a few comments and commit logs

Thanks Christoph for cleaning up all that aged cruft, and thanks everyone
for the reviews.

I was curious about EXPORT_SYMBOL_GPL_FUTURE and EXPORT_UNUSED_SYMBOL
variants, and found that most of that stuff was introduced between
2006 - 2008. All the of the unused symbols were removed and gpl future
symbols were converted to gpl quite a long time ago, and I don't
believe these export types have been used ever since. So I
think it's safe to retire those export types now.

The patchset looks good so far. After Miroslav's comments are
addressed, I'll wait an extra day or two in case there are more
comments before queueing them onto modules-next. I can take the first
two patches as well provided the acks are there (I think patch 2 is
missing Daniel Vetter's ack from v1 of the series, but I'll add that
back in).

Thanks,

Jessica
