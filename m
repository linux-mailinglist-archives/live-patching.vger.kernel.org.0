Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB5B313114
	for <lists+live-patching@lfdr.de>; Mon,  8 Feb 2021 12:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhBHLk2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Feb 2021 06:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232106AbhBHLhF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Feb 2021 06:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6780F64E40;
        Mon,  8 Feb 2021 11:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612784185;
        bh=fBp9LiWsmCqhuaI9wcJM8SBAr5veZ226g9+wpY2pX+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ubHOUH2l2tFZUF2ynWkVVod7BUYjSKuOSrCEIvHN0ZJyFeqBx8hPUkx8ibDvJM6cp
         nYgvBXrN7yP6JPyVxnB5Vl25KRr4gUYEtwf8ZWhdKErl70xdsLpHW/kxIlsvpTL2KU
         7wshBHn6WQ/X9D2rLICFJKJ6l/CWRLTblBGEIZjFAboNqwhE1W6cXhnVCMmg+s3RK8
         t3HE2TPmQBQPngHWdOQeK67EAanjk7crsmyGh7z9toVdi4bcIA4jwAmSMy7m/GHEBq
         aCd9u393CVZ+h6B9r1/Qqj4tW0JbbTw8jCs10nzwjrpRirqCtk8wVn3xF8/6XFQklM
         6j1XdiBtOr5PQ==
Date:   Mon, 8 Feb 2021 12:36:18 +0100
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
Message-ID: <YCEiMoWRLj+lpNqS@gunter>
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
>
>Diffstat:

Queued on modules-next (along with the updated patch 10).

Thanks everyone,

Jessica
