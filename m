Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948F6261972
	for <lists+live-patching@lfdr.de>; Tue,  8 Sep 2020 20:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732122AbgIHSOT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Sep 2020 14:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730478AbgIHSOR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Sep 2020 14:14:17 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A05EC061573
        for <live-patching@vger.kernel.org>; Tue,  8 Sep 2020 11:14:17 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id z19so164464lfr.4
        for <live-patching@vger.kernel.org>; Tue, 08 Sep 2020 11:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kJ3ljRP1PgRw54jIC5gTvGtyMc45VqFJMstrdbMtx+8=;
        b=T3guH4044UWDX5KPSunMEQmHeqrSj26rDjWAj/+rJoe1eDKvJU3Ic5nCrQ96J5+i+t
         TZ5UQyD1VBTE66WnopwwccZGtD7nym6+GYbaxp2OB+C0cA/LP6AYd7h6ese5jpHgtpUQ
         A1mvhQk+ngGAheHTyaJCRFXabP8OkkaeacE5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kJ3ljRP1PgRw54jIC5gTvGtyMc45VqFJMstrdbMtx+8=;
        b=SiHnSuMUWIejEvUAahF8y2ljTq67/A4CVQ1DTCZDAGiot+HACGlYxJH94pH+1sAISP
         vY2r/SGBLG+xb594iWO5BJttO8d23Zz+dyZukcMDN1z8fpM4Rh4pMv0pIzePmifG2CEz
         zWt7VxOIgzMQ/5oTCkJDEzF22YtlGSIAddNLg1oMZTe8ALQrSo5wZabBjv0LqZY8C02f
         hwbxFgJBKnogxY8LAad7XWhmPrazDVaDsrvldIJC8ebU59kS5p6D9D3n0bquVCRJmvk3
         l6kbDD9rX4vV82HSPxYGU4WWaCv7EyD8JhkBE5pRtPITlGky1HWQBWoHazfWlFhM+Mb0
         qDpw==
X-Gm-Message-State: AOAM532PZsSJ6uQNPyCvj9W61uCcuc7f0AE0h/wPlt8rQgCGVeNMBtsz
        wruSyClREne4pfwJlBTAE3KFdw9Ktd/ZBg==
X-Google-Smtp-Source: ABdhPJxtlVIBruBiINtxiAAXAf86ZuLNXLsaTOoG9Z68oyDgihycb8jtXYkGoViNB6oeBe41q75PTg==
X-Received: by 2002:a05:6512:207:: with SMTP id a7mr118121lfo.127.1599588855350;
        Tue, 08 Sep 2020 11:14:15 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id w26sm137408ljm.30.2020.09.08.11.14.14
        for <live-patching@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 11:14:14 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id x69so170738lff.3
        for <live-patching@vger.kernel.org>; Tue, 08 Sep 2020 11:14:14 -0700 (PDT)
X-Received: by 2002:a19:745:: with SMTP id 66mr135177lfh.142.1599588854033;
 Tue, 08 Sep 2020 11:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200907082036.GC8084@alley>
In-Reply-To: <20200907082036.GC8084@alley>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Sep 2020 11:13:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiZUYjmPLiEaN5uHM4mGyYq8RBFvk=iZKkm9=8NxvcoZQ@mail.gmail.com>
Message-ID: <CAHk-=wiZUYjmPLiEaN5uHM4mGyYq8RBFvk=iZKkm9=8NxvcoZQ@mail.gmail.com>
Subject: Re: [GIT PULL] livepatching for 5.9-rc5
To:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Josh,

On Mon, Sep 7, 2020 at 1:20 AM Petr Mladek <pmladek@suse.com> wrote:
>
> - Workaround "unreachable instruction" objtool warnings that happen
>   with some compiler versions.

I know I said this fixes things for me, but I just realized it doesn't entirely.

I wonder how I missed the remaining one:

   arch/x86/kvm/vmx/vmx.o: warning: objtool:
vmx_handle_exit_irqoff()+0x142: unreachable instruction

so apparently gcc and objtool can still disagree even without that
'-flive-patching'.

The unreachable code in question is after the call to
handle_external_interrupt_irqoff(), and while that function is a bit
odd, in this case I think it's objtool that is wrong.

I think that what happens is that the function doesn't have a 'ret'
instruction, and instead returns by doing a tail-call to
__sanitizer_cov_trace_pc with my config. And maybe that is what
confuses objtool.

This is current tip-of-git of my tree, with a allmodconfig build (but
the actual config will then depend on things like the gcc plugins
being there too, so you may not get exactly the same thing as I do)

Josh? Am I missing something, and the objtool warning is valid? But
yes, that code is doing some very very special stuff with that thunk
call asm, so it's hard to read the asm.

                  Linus
