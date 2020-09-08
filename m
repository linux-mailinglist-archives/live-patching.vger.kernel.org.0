Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EEE261A4D
	for <lists+live-patching@lfdr.de>; Tue,  8 Sep 2020 20:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgIHSei (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Sep 2020 14:34:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38402 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731858AbgIHScr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Sep 2020 14:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599589966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B2G7IynuJTWu26rmvtUiX/MucuRuUehwK9kbE6Qud0s=;
        b=Lg9OJ9MBzGicyQB9DcRDESKpPIQBd3AU09JKew0WqcSl/+5VuEuhfByTDx7buQt7cxNeS3
        FomzA6F76Xpb793rLr8ZyvJxUFEU2FP4KkU30UdD7U5e3zpDNULqE6YAH76twxYsdAk6d+
        CS1caXSLD/OgUp4FXnByslH8kxReYe4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-BEmFX_K2Mwiz9tXCT2NziQ-1; Tue, 08 Sep 2020 14:32:42 -0400
X-MC-Unique: BEmFX_K2Mwiz9tXCT2NziQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E13010050EC;
        Tue,  8 Sep 2020 18:32:41 +0000 (UTC)
Received: from treble (ovpn-117-163.rdu2.redhat.com [10.10.117.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F63E27CC3;
        Tue,  8 Sep 2020 18:32:41 +0000 (UTC)
Date:   Tue, 8 Sep 2020 13:32:39 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [GIT PULL] livepatching for 5.9-rc5
Message-ID: <20200908183239.vhy2txzcmlliul7d@treble>
References: <20200907082036.GC8084@alley>
 <CAHk-=wiZUYjmPLiEaN5uHM4mGyYq8RBFvk=iZKkm9=8NxvcoZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiZUYjmPLiEaN5uHM4mGyYq8RBFvk=iZKkm9=8NxvcoZQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Sep 08, 2020 at 11:13:58AM -0700, Linus Torvalds wrote:
> Josh,
> 
> On Mon, Sep 7, 2020 at 1:20 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> > - Workaround "unreachable instruction" objtool warnings that happen
> >   with some compiler versions.
> 
> I know I said this fixes things for me, but I just realized it doesn't entirely.
> 
> I wonder how I missed the remaining one:
> 
>    arch/x86/kvm/vmx/vmx.o: warning: objtool:
> vmx_handle_exit_irqoff()+0x142: unreachable instruction
> 
> so apparently gcc and objtool can still disagree even without that
> '-flive-patching'.
> 
> The unreachable code in question is after the call to
> handle_external_interrupt_irqoff(), and while that function is a bit
> odd, in this case I think it's objtool that is wrong.
> 
> I think that what happens is that the function doesn't have a 'ret'
> instruction, and instead returns by doing a tail-call to
> __sanitizer_cov_trace_pc with my config. And maybe that is what
> confuses objtool.
> 
> This is current tip-of-git of my tree, with a allmodconfig build (but
> the actual config will then depend on things like the gcc plugins
> being there too, so you may not get exactly the same thing as I do)
> 
> Josh? Am I missing something, and the objtool warning is valid? But
> yes, that code is doing some very very special stuff with that thunk
> call asm, so it's hard to read the asm.

Hm, I don't think I've seen that one.  We saw a similar warning in that
function before, but it was caused by the combination of
CONFIG_UBSAN_ALIGNMENT and CONFIG_UBSAN_TRAP, which I think Kees fixed.

Can you share the .o file?  At least I can't recreate with GCC 9.3.1,
which is all I have at the moment.

-- 
Josh

