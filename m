Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B103E3152
	for <lists+live-patching@lfdr.de>; Fri,  6 Aug 2021 23:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244572AbhHFVpn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Aug 2021 17:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241587AbhHFVpn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Aug 2021 17:45:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC1CC0613CF;
        Fri,  6 Aug 2021 14:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3yo0Z1DqiPntRlxzgzVM4K1c9ilgCH5IdUhCZZNDe9s=; b=YEcpgCfI59SF9Tug3dbXK91OXX
        sq9bPtmNl5qPktHwmAAihU+NGy4EI2Wu4qsPOh1YYDsBUr8cB8XertXL4GuKVn5dzjT+2S1FZ3ks2
        ORtg4pVQ21049fLZZaN+E4/dG2qP3gkRUSMu6HVBgJTI1Z0dMoLe0I09+mcsDE/PnKAall2S/lIq0
        4OTwMTLqvzUBf40IsuaIbSHTe4FUiD3OaquwRjBJ3LNndLJX1vzhAu32F2tb4kqIa7o0oif1GzujM
        u/UJbjCcJ96IbwBmsdqgzM0qVc+m5TsYwt9kBS3BqP+RYOiQHBu6DkLVigbaVerIeFBT58rWnyT3O
        csmQP7Bg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mC7ee-00DgiI-Nc; Fri, 06 Aug 2021 21:45:24 +0000
Date:   Fri, 6 Aug 2021 14:45:24 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        fstests@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de,
        dgilbert@interlog.com, jeyu@kernel.org, osandov@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libkmod-module: add support for a patient module removal
 option
Message-ID: <YQ2tdCZ5YynHtuHB@bombadil.infradead.org>
References: <20210803202417.462197-1-mcgrof@kernel.org>
 <YQrVY8Wxb026TDWN@bombadil.infradead.org>
 <20210804184720.z27u5aymcl5hzqgh@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804184720.z27u5aymcl5hzqgh@ldmartin-desk2>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Aug 04, 2021 at 11:47:20AM -0700, Lucas De Marchi wrote:
> On Wed, Aug 04, 2021 at 10:58:59AM -0700, Luis Chamberlain wrote:
> > On Tue, Aug 03, 2021 at 01:24:17PM -0700, Luis Chamberlain wrote:
> > > + diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
> > <-- snip -->
> > > +		ERR(mod->ctx, "%s refcnt is %ld waiting for it to become 0\n", mod->name, refcnt);
> > 
> > OK after running many tests with this I think we need to just expand
> > this so that the error message only applies when -v is passed to
> > modprobe, otherwise we get the print message every time, and using
> > INFO() doesn't cut it, given the next priority level available to
> > the library is LOG_INFO (6) and when modprobe -v is passed we set the
> > log level to LOG_NOTICE (5), so we need a new NOTICE(). I'll send a v2
> > with that included as a separate patch.
> 
> Or maybe move the sleep to modprobe instead of doing it in the
> library? 

We have a few callers which need to impement the wait, and so having
a library call is one way to share code. I realized this while first
open coding this in each call site and realizing I was just
re-inventing the wheel.

> The sleep(1) seems like an arbitrary number to be introduced
> in the lib.

Indeed, the ideal thing here is to introduce then a timeout, and have
a default setting, which code can override.

> Since kernfs is pollable,
> maybe we could rather introduce an API to
> return the pid in which the application has to wait for

The kernel does not have information to provide userspace any
information for how long it should wait. I mean, in a test case I am
using its an lvm pvremove and for some reason it seems the removal
is asynchronously putting the module refcnt (even though I do not believe
DM_DEFERRED_REMOVE is ever set by default), and I had fixed the kernel's
own asynchronous removal of the request_queue a little while back so
I don't think that's the issue either.

If you mean to consider adding *more* information to the kernel, as
a new feature, I'm afraid any PID triggering a bump in the refcnt is
ephemeral, and so I don't think it would help. It would only be useful
if userspace *knew* it would trigger a recnt bump, and that seems
likely a promise we would probaby want to break any time. Unless we
want to get into the business of granting userspace the ability to
bump refcnt's with new structural information it promises is legit.
Then userspace can query for this. However that still seems overkill,
I can't see a need for it yet.

> and then the
> application can use whatever it wants to poll, including controlling a
> timeout.

A dynamic timeout seems sensible indeed.

> I'm saying this because sleep(1) may be all fine for modprobe, but for
> other applications using libkmod it may not play well with their mainloops
> (and they may want to control both granularity of the sleep and a max
> timeout).

Indeed. A default timeout set into the context seem to be the way to go,
which callers can override. Then modprobe -t <ms_wait> can use this caller to
update the ctx timeout to a setting.

I'll post a v2 with these changes.

  Luis
