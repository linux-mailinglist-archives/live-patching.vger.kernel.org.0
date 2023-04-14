Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCA86E1FDF
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 11:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjDNJxR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 05:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjDNJxO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 05:53:14 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81FFA83CF
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 02:53:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A48CA2F4;
        Fri, 14 Apr 2023 02:53:55 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.21.222])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3196A3F587;
        Fri, 14 Apr 2023 02:53:09 -0700 (PDT)
Date:   Fri, 14 Apr 2023 10:53:03 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, nstange@suse.de, mpdesouza@suse.de,
        broonie@kernel.org, live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
Message-ID: <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Mar 29, 2023 at 02:05:43PM +0200, Miroslav Benes wrote:
> Hi,
> 
> we would like to organize Live Patching Microconference at Linux Plumbers 
> 2023. The conference will take place in Richmond, VA, USA. 13-15 November. 
> https://lpc.events/. The call for proposals has been opened so it is time 
> to start the preparation on our side.
> 
> You can find the proposal below. Comments are welcome. The list of topics 
> is open, so feel free to add more. I tried to add key people to discuss 
> the topics, but the list is not exhaustive. I would like to submit the 
> proposal soonish even though the deadline is on 1 June. I assume that we 
> can update the topics later. My plan is to also organize a proper Call for 
> Topics after the submission and advertise it also on LKML.
> 
> Last but not least it would be nice to have a co-runner of the show. Josh, 
> Joe, any volunteer? :)
> 
> Thank you
> Miroslav
> 
> 
> Proposal
> --------
> The Live Patching microconference at Linux Plumbers 2023 aims to gather
> stakeholders and interested parties to discuss proposed features and
> outstanding issues in live patching.
> 
> Live patching is a critical tool for maintaining system uptime and
> security by enabling fixes to be applied to running systems without the
> need for a reboot. The development of the infrastructure is an ongoing
> effort and while many problems have been resolved and features
> implemented, there are still open questions, some with already submitted
> patch sets, which need to be discussed.
> 
> Live Patching microconferences at the previous Linux Plumbers
> conferences proved to be useful in this regard and helped us to find
> final solutions or at least promising directions to push the development
> forward. It includes for example a support for several architectures
> (ppc64le and s390x were added after x86_64), a late module patching and
> module dependencies and user space live patching.
> 
> Currently proposed topics follow. The list is open though and more will
> be added during the regular Call for Topics.
> 
>   - klp-convert (as means to fix CET IBT limitations) and its 
>     upstreamability
>   - shadow variables, global state transition
>   - kselftests and the future direction of development
>   - arm64 live patching

I'm happy to talk about the kernel-side of arm64 live patching; it'd be good to
get in contact with anyone looking at the arm64 userspace side (e.g.
klp-convert).

I have some topics which overlap between live-patching and general toolchain
bits and pieces, and I'm not sure if they'd be best suited here or in a
toolchain track, e.g.

* How to avoid/minimize the need to reverse-engineer control flow for things
  like ORC generation.

  On the arm64 side we're pretty averse to doing this to generate metadata for
  unwinding (and we might not need to), but there are things objtool does today
  that requires awareness of control-flow (e.g. forward-edge checks for noinstr
  safety).

  Hopefully without a flamewar about DWARF...

* Better compiler support for noinstr and similar properties.

  For example, noinstr functions are currently all noinline, and we can't
  inline a noinstr function into a noinstr function, leading to a painful mix
  of noinstr and __always_inline. Having a mechanism to allow noinstr code to
  be inlined into other noinstr code would be nice.

  Likewise, whether we could somehow get compile-time warnings about unintended
  calls from instrumentable code from noinstr code.

* How is this going to work with rust?

  It's not clear to me whether/how things like ftrace, RELIABLE_STACKTRACE, and
  live-patching are going to work with rust. We probably need to start looking
  soon.

I've Cc'd Nick, Jose, and Miguel, in case they have thoughts.

Mark.

> 
> Key people
> 
>   - Josh Poimboeuf <jpoimboe@kernel.org>
>   - Jiri Kosina <jikos@kernel.org>
>   - Miroslav Benes <mbenes@suse.cz>
>   - Petr Mladek <pmladek@suse.com>
>   - Joe Lawrence <joe.lawrence@redhat.com>
>   - Nicolai Stange <nstange@suse.de>
>   - Marcos Paulo de Souza <mpdesouza@suse.de>
>   - Mark Rutland <mark.rutland@arm.com>
>   - Mark Brown <broonie@kernel.org>
> 
> We encourage all attendees to actively participate in the
> microconference by sharing their ideas, experiences, and insights.
> 
