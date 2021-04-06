Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450A335588D
	for <lists+live-patching@lfdr.de>; Tue,  6 Apr 2021 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345875AbhDFPyn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 6 Apr 2021 11:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhDFPym (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 6 Apr 2021 11:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617724474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GECg07lP5wsIqbFA2Q0Bw1H5A4ajMexc9b0QUtiEUWY=;
        b=cI2GLgvon9l6hRkwem95ROnHMUL7bW2cNgEzkDXSVnzsQ17pAnpgejx0EtKygdbrB0gsT8
        lbMNGLvo/gqXqBzc2+tAc84LgDXvyNcI6K9y8W2JtZXXKclVTCxNrwyncZTL95u3LgqtJT
        awSHfEVxZYEI4JR9nLgU1R3jz0DqW9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-CUodGpTdMkqgH90ht6jzIw-1; Tue, 06 Apr 2021 11:54:30 -0400
X-MC-Unique: CUodGpTdMkqgH90ht6jzIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94AA2800D53;
        Tue,  6 Apr 2021 15:54:27 +0000 (UTC)
Received: from treble (ovpn-116-68.rdu2.redhat.com [10.10.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F97310016FC;
        Tue,  6 Apr 2021 15:54:25 +0000 (UTC)
Date:   Tue, 6 Apr 2021 10:54:23 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>, mbenes@suse.com,
        Minchan Kim <minchan@kernel.org>, keescook@chromium.org,
        dhowells@redhat.com, hch@infradead.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] zram: fix crashes due to use of cpu hotplug
 multistate
Message-ID: <20210406155423.t7dagp24bupudv3p@treble>
References: <20210319190924.GK4332@42.do-not-panic.com>
 <YFjHvUolScp3btJ9@google.com>
 <20210322204156.GM4332@42.do-not-panic.com>
 <YFkWMZ0m9nKCT69T@google.com>
 <20210401235925.GR4332@42.do-not-panic.com>
 <YGbNpLKXfWpy0ZZa@kroah.com>
 <20210402183016.GU4332@42.do-not-panic.com>
 <YGgHg7XCHD3rATIK@kroah.com>
 <20210406003152.GZ4332@42.do-not-panic.com>
 <alpine.LSU.2.21.2104061354110.10372@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2104061354110.10372@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 06, 2021 at 02:00:19PM +0200, Miroslav Benes wrote:
> Hi,
> 
> > > Driver developers will simply have to open code these protections. In
> > > light of what I see on LTP / fuzzing, I suspect the use case will grow
> > > and we'll have to revisit this in the future. But for now, sure, we can
> > > just open code the required protections everywhere to not crash on module
> > > removal.
> > 
> > LTP and fuzzing too do not remove modules.  So I do not understand the
> > root problem here, that's just something that does not happen on a real
> > system.
> 
> If I am not mistaken, the issue that Luis tries to solve here was indeed 
> found by running LTP.
> 
> > On Sat, Apr 03, 2021 at 08:13:23AM +0200, Greg KH wrote:
> > > On Fri, Apr 02, 2021 at 06:30:16PM +0000, Luis Chamberlain wrote:
> > > > On Fri, Apr 02, 2021 at 09:54:12AM +0200, Greg KH wrote:
> > > > > No, please no.  Module removal is a "best effort",
> > > > 
> > > > Not for live patching. I am not sure if I am missing any other valid
> > > > use case?
> > > 
> > > live patching removes modules?  We have so many code paths that are
> > > "best effort" when it comes to module unloading, trying to resolve this
> > > one is a valiant try, but not realistic.
> > 
> > Miroslav, your input / help here would be valuable. I did the
> > generalization work because you said it would be worthy for you too...
> 
> Yes, we have the option to revert and remove the existing live patch from 
> the system. I am not sure how (if) it is used in practice.
> 
> At least at SUSE we do not support the option. But we are only one of the 
> many downstream users. So yes, there is the option.

Same for Red Hat.  Unloading livepatch modules seems to work fine, but
isn't officially supported.

That said, if rmmod is just considered a development aid, and we're
going to be ignoring bugs, we should make it official with a new
TAINT_RMMOD.

-- 
Josh

