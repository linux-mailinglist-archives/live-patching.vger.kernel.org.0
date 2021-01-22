Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACE9300EC7
	for <lists+live-patching@lfdr.de>; Fri, 22 Jan 2021 22:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbhAVVUM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jan 2021 16:20:12 -0500
Received: from linux.microsoft.com ([13.77.154.182]:39976 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730013AbhAVVQG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jan 2021 16:16:06 -0500
Received: from [192.168.254.32] (unknown [47.187.219.45])
        by linux.microsoft.com (Postfix) with ESMTPSA id 521CE20B7192;
        Fri, 22 Jan 2021 13:15:13 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 521CE20B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1611350114;
        bh=LmVa0B7QKVLtgYQ+R0kakMd+3Q+60r35qr0JwnFm7VU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jkkEH3MPRrsvDvseero3sthB72ZWEg+KC707Ywto3Jy/Ep77Tj+qFhv1okjYDd/VE
         /Dx5oxMI4B/ZDYDhnywVkyDim4CKfsMrBcvwer389JXBAyaa0r9CpdSjUIZvG+IbEQ
         t5ca9vl/Myy4u6O+zq2+QpBXLlGr0Lom72t4ht7A=
Subject: Re: [RFC PATCH 00/17] objtool: add base support for arm64
To:     Mark Brown <broonie@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Julien Thierry <jthierry@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-hardening@vger.kernel.org, live-patching@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Kees Cook <keescook@chromium.org>
References: <20210120173800.1660730-1-jthierry@redhat.com>
 <CAMj1kXHO0wgcZ4ZDxj1vS9s7Szfpz8Nz=SAW_=Dnnjy+S9AtyQ@mail.gmail.com>
 <186bb660-6e70-6bbf-4e96-1894799c79ce@redhat.com>
 <CAMj1kXHznGnN2UEai1c2UgyKuTFCS5SZ+qGR6VJwyCuccViw_A@mail.gmail.com>
 <YAlkOFwkb6/hFm1Q@hirez.programming.kicks-ass.net>
 <CAMj1kXE+675mbS66kteKHNfcrco84WTaEL6ncVkkV7tQgbMpFw@mail.gmail.com>
 <20210121185452.fxoz4ehqfv75bdzq@treble>
 <20210122174342.GG6391@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <bebccb15-1195-c004-923e-74d8444250e1@linux.microsoft.com>
Date:   Fri, 22 Jan 2021 15:15:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210122174342.GG6391@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 1/22/21 11:43 AM, Mark Brown wrote:
> On Thu, Jan 21, 2021 at 12:54:52PM -0600, Josh Poimboeuf wrote:
> 
>> 2) The shadow stack idea sounds promising -- how hard would it be to
>>    make a prototype reliable unwinder?
> 
> In theory it doesn't look too hard and I can't see a particular reason
> not to try doing this - there's going to be edge cases but hopefully for
> reliable stack trace they're all in areas where we would be happy to
> just decide the stack isn't reliable anyway, things like nesting which
> allocates separate shadow stacks for each nested level for example.
> I'll take a look.
> 

I am a new comer to this discussion and I am learning. Just have some
questions. Pardon me if they are obvious or if they have already been
asked and answered.

Doesn't Clang already have support for a shadow stack implementation for ARM64?
We could take a look at how Clang does it.

Will there not be a significant performance hit? May be, some of it can be
mitigated by using a parallel shadow stack rather than a compact one.

Are there any longjmp style situations in the kernel where the stack is
unwound by several frames? In these cases, the shadow stack must be unwound
accordingly.

Madhavan

> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
