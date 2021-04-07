Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732F9356E2C
	for <lists+live-patching@lfdr.de>; Wed,  7 Apr 2021 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352779AbhDGOKT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 7 Apr 2021 10:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352778AbhDGOKP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 7 Apr 2021 10:10:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093E2C061756;
        Wed,  7 Apr 2021 07:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7sbNlPhjEYhjZGoqh242EY0zecg74ddTeHMZo1SyTcw=; b=Wg/1qF2fbwWrJpzQawsS///gGp
        XQ9StNDGIlaE3iPHUUb3EGaAuZk2Zc5FRfDzFVgQZnL7sNTPoKY+C7yb1BimFYOjpPYqbMMS5w4Kx
        uFOJz/gGd5nC9D+EK9D4aV0wggSSSTOt0Ppq2/iTnGiqkpBL5Wi8U0ZbpuikTIQioX+tdLuJbkBEn
        JepDILTjCM2VhjRCmh1TAnRmTciNhkCY0wDeHtiRCHNnX7ba4kQnsc2MceQxNCQ7CxkH0Tq2mP4EZ
        4DRK6DiL203mb0O8hrMQXfRbUxcED+K8eNRwHaXWs+8SxMTj0qbAnM80cwc8x9G7NgZSsppNDFm2O
        fTutICVg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lU8sL-0055qy-2a; Wed, 07 Apr 2021 14:09:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 39616300219;
        Wed,  7 Apr 2021 16:09:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1B72A2BBEA8E2; Wed,  7 Apr 2021 16:09:44 +0200 (CEST)
Date:   Wed, 7 Apr 2021 16:09:44 +0200
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
Message-ID: <YG29KAuOHbJd3Bll@hirez.programming.kicks-ass.net>
References: <YFjHvUolScp3btJ9@google.com>
 <20210322204156.GM4332@42.do-not-panic.com>
 <YFkWMZ0m9nKCT69T@google.com>
 <20210401235925.GR4332@42.do-not-panic.com>
 <YGbNpLKXfWpy0ZZa@kroah.com>
 <20210402183016.GU4332@42.do-not-panic.com>
 <YGgHg7XCHD3rATIK@kroah.com>
 <20210406003152.GZ4332@42.do-not-panic.com>
 <alpine.LSU.2.21.2104061354110.10372@pobox.suse.cz>
 <20210406155423.t7dagp24bupudv3p@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406155423.t7dagp24bupudv3p@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 06, 2021 at 10:54:23AM -0500, Josh Poimboeuf wrote:

> Same for Red Hat.  Unloading livepatch modules seems to work fine, but
> isn't officially supported.
> 
> That said, if rmmod is just considered a development aid, and we're
> going to be ignoring bugs, we should make it official with a new
> TAINT_RMMOD.

Another option would be to have live-patch modules leak a module
reference by default, except when some debug sysctl is set or something.
Then only those LP modules loaded while the sysctl is set to 'YOLO' can
be unloaded.
