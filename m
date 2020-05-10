Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D769C1CCE48
	for <lists+live-patching@lfdr.de>; Sun, 10 May 2020 23:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgEJVvI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 10 May 2020 17:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgEJVvI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sun, 10 May 2020 17:51:08 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2109E20801;
        Sun, 10 May 2020 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589147467;
        bh=i4ZPjwrBwKNSFaeYz7pCXGUsqvDB4d5elw4u0iWikqo=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=qitNJdcXLZqpDlIrtjn2N+p/iDXOHEpBMDjVawS+xKO4G0vgNsROFtKDM3gtIOKM3
         NgEzu68AHqBKTw21Sc47X+ZemTTvI2x3BjyTL/cnsBIy925Ip5eCw4QutpXEk8mgbQ
         OoFo4mNNfWnnfdele7WPBIgTPdb0sP648yH6JZCc=
Date:   Sun, 10 May 2020 23:51:04 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: adjust to livepatch .klp.arch removal
In-Reply-To: <20200509073258.5970-1-lukas.bulwahn@gmail.com>
Message-ID: <nycvar.YFH.7.76.2005102350050.25812@cbobk.fhfr.pm>
References: <20200509073258.5970-1-lukas.bulwahn@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, 9 May 2020, Lukas Bulwahn wrote:

> Commit 1d05334d2899 ("livepatch: Remove .klp.arch") removed
> arch/x86/kernel/livepatch.c, but missed to adjust the LIVE PATCHING entry
> in MAINTAINERS.
> 
> Since then, ./scripts/get_maintainer.pl --self-test=patterns complains:
> 
>   warning: no file matches  F:  arch/x86/kernel/livepatch.c
> 
> So, drop that obsolete file entry in MAINTAINERS.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

I've added

	Fixes: 1d05334d2899 ("livepatch: Remove .klp.arch")

and applied, thanks.

-- 
Jiri Kosina
SUSE Labs

