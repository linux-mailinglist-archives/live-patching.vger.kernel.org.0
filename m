Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA226E2F19
	for <lists+live-patching@lfdr.de>; Sat, 15 Apr 2023 07:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjDOFGE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 15 Apr 2023 01:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOFGD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 15 Apr 2023 01:06:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FB94C2B;
        Fri, 14 Apr 2023 22:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3A2361BC5;
        Sat, 15 Apr 2023 05:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1B1C433D2;
        Sat, 15 Apr 2023 05:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681535159;
        bh=XOIJuxXHCj+rkGybuZPerdCBU1hgQaWT6pZnlBVE1nE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3U9k+O3VHIIZEC2+EhtmpMMVSjZZzq3kTeqKL2XzTLENPtmfxZzhWjNbHiyghVKM
         lCKJkJO/YGCgTbuUessQ/5nzd5zXACdYVEKGlHGrvkgBpiS0Gyn73esckKwSnY3kUQ
         xcxVn1Dx6QxoUJHheqJemZibhbSh+S9XKe4U75b9jkFa51xuaZvzxPIIs2Xw5Di9mi
         v0gl+uMQzh1IJynRN2MCMjhftuIBKrszkBD/gG+Bd3PxjlXAiHdEiO5bfu+fdV/f+6
         NAGaBPOLGAp56Nn1udzmfs7qnYk8cAdz8W4HIJTYCRzLle4VY/E9HBt2vI6IGOkff2
         bSZlbNywZ4uEw==
Date:   Fri, 14 Apr 2023 22:05:56 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-toolchains@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <20230415050556.isimfnqnsgwmerkf@treble>
References: <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N>
 <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
 <20230412050106.7v4s3lalg43i6ciw@treble>
 <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
 <20230412155221.2l2mqsyothseymeq@treble>
 <cf583799-1a8d-4dd2-8bc7-c8fbb07f29ab@linux.microsoft.com>
 <20230413163035.ttar5uexrpldz3yl@treble>
 <4e5029f4-be42-ef23-1eab-a6cfff49527c@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4e5029f4-be42-ef23-1eab-a6cfff49527c@linux.microsoft.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 14, 2023 at 11:27:44PM -0500, Madhavan T. Venkataraman wrote:
> >> What I meant is - if SFrame is implemented by simply extracting unwind info from
> >> DWARF data and placing it in a separate section (as it is probably implemented now),
> >> then what you say is totally true. But if the compiler folks agree to make SFrame reliable,
> >> then either they have to make DWARF reliable. Or, they have to implement SFrame as a
> >> separate feature and make it reliable. The former is tough to do as DWARF has a lot of complexity.
> >> The latter is a lot easier to do.
> > 
> > [ adding linux-toolchains ]
> > 
> > I don't think ensuring reliability is an easy task, regardless of the
> > complexity of the unwinding format.
> > 
> > Whether it's SFrame or DWARF/eh_frame, the question would be how to
> > ensure it's always reliable for a compiler "power user" like the kernel
> > which has many edge cases (including lots of inline asm which the
> > compiler has no visibility to) and which uses unwinding for more than
> > just debugging.
> > 
> > It would need some kind of black-box testing on a complex code base.
> > (hint: kind of like what objtool already does today)
> > 
> 
> I could use the ORC data I generate by using the decoder against the SFrame data.
> A function is reliable only if both data sources agree for the whole function.

This is somewhat similar to what I'm saying in another thread:

  https://lore.kernel.org/live-patching/20230415043949.7y4tvshe26zday3e@treble/

If objtool and DWARF/SFrame agree, all is well.

> Also, in my approach, the actual frame pointer is dynamically checked against the
> frame pointer computed from the unwind data. Any mismatch indicates an unreliable stack trace.
> 
> IMHO, this is sufficient to provide livepatch. Do you agree?

The dynamic reliable stacktrace checks for CONFIG_FRAME_POINTER on x86
are much simpler, as they don't require ORC or any other metadata.  They
just need to detect preemption and page faults on the stack, and to
identify the end of the stack.  Those simple dynamic checks, combined
with objtool's build-time frame pointer validation, worked very well
until we switched to ORC.

So I'm not sure I see the benefit of the additional complexity involved
in cross-checking frame pointers with ORC at runtime.  But I'm just a
bystander.  What really matters is what the arm64 folks think ;-)

-- 
Josh
