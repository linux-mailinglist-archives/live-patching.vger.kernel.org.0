Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792A3355306
	for <lists+live-patching@lfdr.de>; Tue,  6 Apr 2021 14:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343650AbhDFMAa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 6 Apr 2021 08:00:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:48934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343634AbhDFMA3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 6 Apr 2021 08:00:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BD70EB15D;
        Tue,  6 Apr 2021 12:00:19 +0000 (UTC)
Date:   Tue, 6 Apr 2021 14:00:19 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
cc:     mbenes@suse.com, Minchan Kim <minchan@kernel.org>,
        keescook@chromium.org, dhowells@redhat.com, hch@infradead.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH 1/2] zram: fix crashes due to use of cpu hotplug
 multistate
In-Reply-To: <20210406003152.GZ4332@42.do-not-panic.com>
Message-ID: <alpine.LSU.2.21.2104061354110.10372@pobox.suse.cz>
References: <20210312183238.GW4332@42.do-not-panic.com> <YEvA1dzDsFOuKdZ/@google.com> <20210319190924.GK4332@42.do-not-panic.com> <YFjHvUolScp3btJ9@google.com> <20210322204156.GM4332@42.do-not-panic.com> <YFkWMZ0m9nKCT69T@google.com> <20210401235925.GR4332@42.do-not-panic.com>
 <YGbNpLKXfWpy0ZZa@kroah.com> <20210402183016.GU4332@42.do-not-panic.com> <YGgHg7XCHD3rATIK@kroah.com> <20210406003152.GZ4332@42.do-not-panic.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

> > Driver developers will simply have to open code these protections. In
> > light of what I see on LTP / fuzzing, I suspect the use case will grow
> > and we'll have to revisit this in the future. But for now, sure, we can
> > just open code the required protections everywhere to not crash on module
> > removal.
> 
> LTP and fuzzing too do not remove modules.  So I do not understand the
> root problem here, that's just something that does not happen on a real
> system.

If I am not mistaken, the issue that Luis tries to solve here was indeed 
found by running LTP.

> On Sat, Apr 03, 2021 at 08:13:23AM +0200, Greg KH wrote:
> > On Fri, Apr 02, 2021 at 06:30:16PM +0000, Luis Chamberlain wrote:
> > > On Fri, Apr 02, 2021 at 09:54:12AM +0200, Greg KH wrote:
> > > > No, please no.  Module removal is a "best effort",
> > > 
> > > Not for live patching. I am not sure if I am missing any other valid
> > > use case?
> > 
> > live patching removes modules?  We have so many code paths that are
> > "best effort" when it comes to module unloading, trying to resolve this
> > one is a valiant try, but not realistic.
> 
> Miroslav, your input / help here would be valuable. I did the
> generalization work because you said it would be worthy for you too...

Yes, we have the option to revert and remove the existing live patch from 
the system. I am not sure how (if) it is used in practice.

At least at SUSE we do not support the option. But we are only one of the 
many downstream users. So yes, there is the option.

Miroslav
