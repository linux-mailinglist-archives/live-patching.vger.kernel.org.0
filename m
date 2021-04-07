Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302BC35725D
	for <lists+live-patching@lfdr.de>; Wed,  7 Apr 2021 18:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347758AbhDGQuG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 7 Apr 2021 12:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241671AbhDGQuF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 7 Apr 2021 12:50:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0FBC061756;
        Wed,  7 Apr 2021 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2njEr9ZUa7y9HL1hJAt9pr7cUOGTLQlkQmxjlTPcmNU=; b=TrCYgYVMGO2a+5h6D17m8iexku
        mApqxwXIBwPoLfOBB2PwEiYwbTdSCEvwmlwle9wv0CZzwQugywD6bAsCPSkkVArolQhmMdydbFRyq
        NkSSb3VQkiyv9si8u79pozGy+TVO/UytP2zdqDUtrKQdA+2KBR41N3TCMJgN4VnFmBCJ55A69hcXN
        1scFbLa1trXAgbhZXELrxYOxvT9P8jCK4LqOBUVtvoJTnF6u1kFfehiZvvbdNYNg/EKJLyijjN5SC
        9vOMRpqdnOZuVX7wO5AF92cyNx6j9D1TtjMd2dUmoaRivlEUtuygzIedDwB4AFeXaSuuSUmRFWIZE
        I/jrfcDQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUBLY-00EmfR-8s; Wed, 07 Apr 2021 16:48:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 956E43001FB;
        Wed,  7 Apr 2021 18:48:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7EC0F23D3AF86; Wed,  7 Apr 2021 18:48:03 +0200 (CEST)
Date:   Wed, 7 Apr 2021 18:48:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
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
Message-ID: <YG3iQ82gYkcp4G5Q@hirez.programming.kicks-ass.net>
References: <YFkWMZ0m9nKCT69T@google.com>
 <20210401235925.GR4332@42.do-not-panic.com>
 <YGbNpLKXfWpy0ZZa@kroah.com>
 <20210402183016.GU4332@42.do-not-panic.com>
 <YGgHg7XCHD3rATIK@kroah.com>
 <20210406003152.GZ4332@42.do-not-panic.com>
 <alpine.LSU.2.21.2104061354110.10372@pobox.suse.cz>
 <20210406155423.t7dagp24bupudv3p@treble>
 <YG29KAuOHbJd3Bll@hirez.programming.kicks-ass.net>
 <20210407153031.m4gg3rsgwlr432ba@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407153031.m4gg3rsgwlr432ba@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 07, 2021 at 10:30:31AM -0500, Josh Poimboeuf wrote:
> On Wed, Apr 07, 2021 at 04:09:44PM +0200, Peter Zijlstra wrote:
> > On Tue, Apr 06, 2021 at 10:54:23AM -0500, Josh Poimboeuf wrote:
> > 
> > > Same for Red Hat.  Unloading livepatch modules seems to work fine, but
> > > isn't officially supported.
> > > 
> > > That said, if rmmod is just considered a development aid, and we're
> > > going to be ignoring bugs, we should make it official with a new
> > > TAINT_RMMOD.
> > 
> > Another option would be to have live-patch modules leak a module
> > reference by default, except when some debug sysctl is set or something.
> > Then only those LP modules loaded while the sysctl is set to 'YOLO' can
> > be unloaded.
> 
> The issue is broader than just live patching.
> 
> My suggestion was that if we aren't going to fix bugs in kernel module
> unloading, then unloading modules shouldn't be supported, and should
> taint the kernel.

Hold up, what? However much I dislike modules (and that is lots), if you
don't want to support rmmod, you have to leak a reference to self in
init. Barring that you get to fix any and all unload bugs.
