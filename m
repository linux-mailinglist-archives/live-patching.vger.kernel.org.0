Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5307F6DDC05
	for <lists+live-patching@lfdr.de>; Tue, 11 Apr 2023 15:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjDKNZU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Apr 2023 09:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjDKNZS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Apr 2023 09:25:18 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E501558E;
        Tue, 11 Apr 2023 06:25:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C126D75;
        Tue, 11 Apr 2023 06:26:00 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.20.166])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA9283F6C4;
        Tue, 11 Apr 2023 06:25:13 -0700 (PDT)
Date:   Tue, 11 Apr 2023 14:25:11 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <ZDVft9kysWMfTiZW@FVFF77S0Q05N>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 07, 2023 at 10:40:07PM -0500, Madhavan T. Venkataraman wrote:
> Hi Mark,
> 
> Sorry for the long delay in responding. Was caught up in many things.
> My responses inline..
> 
> On 3/23/23 12:17, Mark Rutland wrote:
> > Hi Madhavan,
> > 
> > At a high-level, I think this still falls afoul of our desire to not reverse
> > engineer control flow from the binary, and so I do not think this is the right
> > approach. I've expanded a bit on that below.
> > 
> > I do think it would be nice to have *some* of the objtool changes, as I do
> > think we will want to use objtool for some things in future (e.g. some
> > build-time binary patching such as table sorting).
> 
> OK. I have been under the impression that the arm64 folks are basically OK with
> Objtool's approach of reverse engineering from the binary. I did not see
> any specific objections to previously submitted patches based on this approach
> including mine.

This has admittedly changed over time, but the preference to avoid
reverse-engineering control flow has been around for a while. For example,
during LPC 2021's "objtool on arm64" session:

  https://lpc.events/event/11/contributions/971/

... where Will and I expressed strong desires to get the compiler to help,
whether that's compiler-generated metadata, (agreed upon) restrictions on code
generation, or something else.

[...]

> > There's a more fundamental issue here in that objtool has to reverse-engineer
> > control flow, and so even if the kernel code and compiled code generation is
> > *perfect*, it's possible that objtool won't recognise the structure of the
> > generated code, and won't be able to reverse-engineer the correct control flow.
> > 
> > We've seen issues where objtool didn't understand jump tables, so support for
> > that got disabled on x86. A key objection from the arm64 side is that we don't
> > want to disable compile code generation strategies like this. Further, as
> > compiles evolve, their code generation strategies will change, and it's likely
> > there will be other cases that crop up. This is inherently fragile.
> > 
> > The key objections from the arm64 side is that we don't want to
> > reverse-engineer details from the binary, as this is complex, fragile, and
> > unstable. This is why we've previously suggested that we should work with
> > compiler folk to get what we need.
> > 
> 
> So, what exactly do you have in mind? What help can the compiler folk provide?

There are several possibilities, e.g.

* Generate some simple metadata that tells us for each PC whether to start an
  unwind from the LR or FP. My understanding was that SFrame *might* be
  sufficient for this.

  We might need some custom metadata for assembly (e.g. exception entry,
  trampolines), but it'd be ok for that to be different.

* Agree upon some restricted patterns for code generation (e.g. fixed
  prologues/epilogues), so that we can identify whether to use LR or FP based
  on the PC and a symbol lookup.

> By your own argument, we cannot rely on the compiler as compiler implementations,
> optimization strategies, etc can change in ways that are incompatible with any
> livepatch implementation.

That's not quite my argument.

My argument is that if we assume some set of properties that compiler folk
never agreed to (and were never made aware of), then compiler folk are well
within their rights to change the compiler such that it doesn't provide those
properties, and it's very likely that such expectation will be broken. We've
seen that happen before (e.g. with jump tables).

Consequently I think we should be working with compiler folk to agree upon some
solution, where compiler folk will actually try to maintain the properties we
depend upon (and e.g. they could have tests for). That sort of co-design has
worked well so far (e.g. with things like kCFI).

Ideally we'd have people in the same room to have a discussion (e.g. at LPC).

> Also, there can always be bugs in the compiler implementations.

I don't disagree with that.

> Can you please elaborate? Are we looking for a way for the compiler folks to
> provide us with something that we can use to implement reliable stack trace?

I tried to do so a bit above.

I'm looking for some agreement between kernel folk and compiler folk on a
reliable mechanism. That might be something that already exists, or something
new. It might be metadata or some restrictions on code generation.

> > I'll note that at the last Linux Plumbers Conference, there was a discussion
> > about what is now called SFrame, which *might* give us sufficient information,
> > but I have not had the time to dig into that as I have been chasing other
> > problems and trying to get other infrastructure in place.
> 
> I will try to locate the link. If you can provide me a link, that would be greatly
> appreciated. I will study their SFrame proposal.

From looking around, that session was:

  https://lpc.events/event/16/contributions/1177/

At the time it was called CTF Frame, but got renamed to SFrame.

I'm not sure where to find the most recent documentation. As I mentioned above
I have not had the time to look in detail.

> >> 		FWIW, I have also compared the CFI I am generating with DWARF
> >> 		information that the compiler generates. The CFIs match a
> >> 		100% for Clang. In the case of gcc, the comparison fails
> >> 		in 1.7% of the cases. I have analyzed those cases and found
> >> 		the DWARF information generated by gcc is incorrect. The
> >> 		ORC generated by my Objtool is correct.
> > 
> > Have you reported this to the GCC folk, and can you give any examples?
> > I'm sure they would be interested in fixing this, regardless of whether we end
> > up using it.
> 
> I will try to get the data again and put something together and send it to the
> gcc folks.

Thanks for doing so; that's much appreciated!

Thanks, 
Mark.
