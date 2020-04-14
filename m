Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDE21A8B17
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505017AbgDNTjQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 15:39:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52491 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2505003AbgDNTjC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 15:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586893141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RUlH4sbSgo9eT5+QKvwXQtoxUNAaT+Wa5wO2eVFJNO0=;
        b=CzCmIF6lBbpPKVMqXaJFh30Je7aWjdzUydqhA07g5S5X/vsrbl50w1J6S3zIpXR6Tq+7f2
        /euGa9BafelOVgNMrwmIsgUj/VrpxWzXIwfzrebY7ikgVfMrtMU0va1G5i42OwnIL0St/2
        fl0AhcPciZQqWWKQ2WDI3BT/ygQe2MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-UVDK63RMMBK0YMgqki-D8Q-1; Tue, 14 Apr 2020 15:08:18 -0400
X-MC-Unique: UVDK63RMMBK0YMgqki-D8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 253AE800D53;
        Tue, 14 Apr 2020 19:08:17 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7103B126518;
        Tue, 14 Apr 2020 19:08:16 +0000 (UTC)
Date:   Tue, 14 Apr 2020 14:08:14 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200414190814.glra2gceqgy34iyx@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <20200414182726.GF2483@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200414182726.GF2483@worktop.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 14, 2020 at 08:27:26PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 14, 2020 at 11:28:36AM -0500, Josh Poimboeuf wrote:
> > Better late than never, these patches add simplifications and
> > improvements for some issues Peter found six months ago, as part of his
> > non-writable text code (W^X) cleanups.
> 
> Excellent stuff, thanks!!
>
> I'll go brush up these two patches then:
> 
>   https://lkml.kernel.org/r/20191018074634.801435443@infradead.org
>   https://lkml.kernel.org/r/20191018074634.858645375@infradead.org

Ah right, I meant to bring that up.  I actually played around with those
patches.  While it would be nice to figure out a way to converge the
ftrace module init, I didn't really like the first patch.

It bothers me that both the notifiers and the module init() both see the
same MODULE_STATE_COMING state, but only in the former case is the text
writable.

I think it's cognitively simpler if MODULE_STATE_COMING always means the
same thing, like the comments imply, "fully formed" and thus
not-writable:

enum module_state {
	MODULE_STATE_LIVE,	/* Normal state. */
	MODULE_STATE_COMING,	/* Full formed, running module_init. */
	MODULE_STATE_GOING,	/* Going away. */
	MODULE_STATE_UNFORMED,	/* Still setting it up. */
};

And, it keeps tighter constraints on what a notifier can do, which is a
good thing if we can get away with it.

> and write a patch that makes the x86 code throw a wobbly on W+X.
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks!

-- 
Josh

