Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CDA357063
	for <lists+live-patching@lfdr.de>; Wed,  7 Apr 2021 17:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbhDGPdE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 7 Apr 2021 11:33:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235561AbhDGPdE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 7 Apr 2021 11:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617809574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4jXDVYNZhoFNYiKZYrtZsKuCVb4vwBIdNB0gpCFJ6N8=;
        b=Q6BWGgbnQbjJwxfpQo+9IDRthjF3aRmtkP/264M3/Wh8qsmVGyUbj4gesk07F5pNYQwph1
        wXpFyBI4lIj1m/Af+RmqxOPXSIz3qLknAYcndM9PmSmnRo8GJxjeapZ65nIvDP0ZJ8GMWn
        SCDM5J4i8Ky8d1sqSSe0VrVWiChfgyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-51rTN3sKNQOCggXX2cxiZQ-1; Wed, 07 Apr 2021 11:30:39 -0400
X-MC-Unique: 51rTN3sKNQOCggXX2cxiZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78CFB9F92C;
        Wed,  7 Apr 2021 15:30:37 +0000 (UTC)
Received: from treble (ovpn-116-68.rdu2.redhat.com [10.10.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6C505D6CF;
        Wed,  7 Apr 2021 15:30:33 +0000 (UTC)
Date:   Wed, 7 Apr 2021 10:30:31 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Greg KH <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>, mbenes@suse.com,
        Minchan Kim <minchan@kernel.org>, keescook@chromium.org,
        dhowells@redhat.com, hch@infradead.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 1/2] zram: fix crashes due to use of cpu hotplug
 multistate
Message-ID: <20210407153031.m4gg3rsgwlr432ba@treble>
References: <20210322204156.GM4332@42.do-not-panic.com>
 <YFkWMZ0m9nKCT69T@google.com>
 <20210401235925.GR4332@42.do-not-panic.com>
 <YGbNpLKXfWpy0ZZa@kroah.com>
 <20210402183016.GU4332@42.do-not-panic.com>
 <YGgHg7XCHD3rATIK@kroah.com>
 <20210406003152.GZ4332@42.do-not-panic.com>
 <alpine.LSU.2.21.2104061354110.10372@pobox.suse.cz>
 <20210406155423.t7dagp24bupudv3p@treble>
 <YG29KAuOHbJd3Bll@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YG29KAuOHbJd3Bll@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 07, 2021 at 04:09:44PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 06, 2021 at 10:54:23AM -0500, Josh Poimboeuf wrote:
> 
> > Same for Red Hat.  Unloading livepatch modules seems to work fine, but
> > isn't officially supported.
> > 
> > That said, if rmmod is just considered a development aid, and we're
> > going to be ignoring bugs, we should make it official with a new
> > TAINT_RMMOD.
> 
> Another option would be to have live-patch modules leak a module
> reference by default, except when some debug sysctl is set or something.
> Then only those LP modules loaded while the sysctl is set to 'YOLO' can
> be unloaded.

The issue is broader than just live patching.

My suggestion was that if we aren't going to fix bugs in kernel module
unloading, then unloading modules shouldn't be supported, and should
taint the kernel.

-- 
Josh

