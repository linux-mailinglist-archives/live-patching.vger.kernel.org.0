Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12AE6DEAD6
	for <lists+live-patching@lfdr.de>; Wed, 12 Apr 2023 07:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjDLFBY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Apr 2023 01:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDLFBX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Apr 2023 01:01:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F61F2D66;
        Tue, 11 Apr 2023 22:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF15A62DFE;
        Wed, 12 Apr 2023 05:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C868C433EF;
        Wed, 12 Apr 2023 05:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681275669;
        bh=G34y1UTsgrhc2za6yW+gBMsV0zsh6UXi4C/xqhhs5j0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BHVEiwfcg0/EU4oYhR236DrW8YUs8OMXWN7A4yezlr2i/5mCguZk+rTijhhH8CCpp
         zNIL7tsecA1Wso4RBu+fCrewkQIXm6L5qUfWHKn2SYadgBhxHQ7VG2ogeJSllt+S6w
         W3Sve0L8FZGJkx4b/ikC/9kcdTQq/SRq64FoGehSxUScIGaISjL5oFcmcp29K1MW+Q
         06xgo6kFG+rQaylJc2koHBWMEenS5ISHD9uDkYFgb4R3fCSp7NbJmGeEzCsmEAOFTE
         puRAA5r1pGwW9UppV+YSQKa0BFatH17WbDzxX7PjZya9RjDgGlPwQO0cHwvcfaE9Xs
         qrnh82/uSsgDw==
Date:   Tue, 11 Apr 2023 22:01:06 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <20230412050106.7v4s3lalg43i6ciw@treble>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N>
 <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 11, 2023 at 11:48:21PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 4/11/23 23:17, Josh Poimboeuf wrote:
> > On Tue, Apr 11, 2023 at 02:25:11PM +0100, Mark Rutland wrote:
> >>> By your own argument, we cannot rely on the compiler as compiler implementations,
> >>> optimization strategies, etc can change in ways that are incompatible with any
> >>> livepatch implementation.
> >>
> >> That's not quite my argument.
> >>
> >> My argument is that if we assume some set of properties that compiler folk
> >> never agreed to (and were never made aware of), then compiler folk are well
> >> within their rights to change the compiler such that it doesn't provide those
> >> properties, and it's very likely that such expectation will be broken. We've
> >> seen that happen before (e.g. with jump tables).
> >>
> >> Consequently I think we should be working with compiler folk to agree upon some
> >> solution, where compiler folk will actually try to maintain the properties we
> >> depend upon (and e.g. they could have tests for). That sort of co-design has
> >> worked well so far (e.g. with things like kCFI).
> >>
> >> Ideally we'd have people in the same room to have a discussion (e.g. at LPC).
> > 
> > That was the goal of my talk at LPC last year:
> > 
> >   https://lpc.events/event/16/contributions/1392/
> > 
> > We discussed having the compiler annotate the tricky bits of control
> > flow, mainly jump tables and noreturns.  It's still on my TODO list to
> > prototype that.
> > 
> > Another alternative which has been suggested in the past by Indu and
> > others is for objtool to use DWARF/sframe as an input to help guide it
> > through the tricky bits.
> > 
> 
> I read through the SFrame spec file briefly. It looks like I can easily adapt my
> version 1 of the livepatch patchset which was based on DWARF to SFrame. If the compiler
> folks agree to properly support and maintain SFrame, then I could send the next version
> of the patchset based on SFrame.
> 
> But I kinda need a clear path forward before I implement anything. I request the arm64
> folks to comment on the above approach. Would it be useful to initiate an email discussion
> with the compiler folks on what they plan to do to support SFrame? Or, should this all
> happen face to face in some forum like LPC?

SFrame is basically a simplified version of DWARF unwind, using it as an
input to objtool is going to have the same issues I mentioned below (and
as was discussed with your v1).

> > That seems more fragile -- as Madhavan mentioned, GCC-generated DWARF
> > has some reliability issues -- and also defeats some of the benefits of
> > reverse-engineering in the first place (we've found many compiler bugs
> > and other surprising kernel-compiler interactions over the years).
> > 
> > Objtool's understanding of the control flow graph has been really
> > valuable for reasons beyond live patching (e.g., noinstr and uaccess
> > validation), it's definitely worth finding a way to make that more
> > sustainable.

-- 
Josh
