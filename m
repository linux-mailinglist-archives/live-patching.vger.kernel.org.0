Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A5F6DEA46
	for <lists+live-patching@lfdr.de>; Wed, 12 Apr 2023 06:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjDLER6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Apr 2023 00:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDLER5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Apr 2023 00:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B232680;
        Tue, 11 Apr 2023 21:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5CD462DBD;
        Wed, 12 Apr 2023 04:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E62C433D2;
        Wed, 12 Apr 2023 04:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681273075;
        bh=yoBa4zZy5EZ5HaeskMPV+eVwYuCxAvjPTogRpMPVZiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RHmJlxIK34PuVSk/lQxnNm8lQO72qp7KAo9lCnjS2jnonAhIkdoIEFkPCSEFS9CXv
         ujvDjptBUNdG1FpkDL0ARd8kJoU5eb+AV4xTTRb7wJoTDabYmGm4LGvWthV+B8a9lT
         aRjTjF1sfesD0CQVs+ZTwEqs2g1c5PO4qSyjro8K3ngAknTRcCVpRzrNQOWRptvcb9
         ipo5ejJ4CsqV1mvKlQwhqlKmYzOH/OLdPFphuxSTPUikBkAGUAFhmawAuub9Kh6918
         IpgPhDybcB891LVIC46G3ZYeEO+PzurSps9zv9zWEvQs884VlgDuzv+kjJJcxsIuAw
         5uLOO6fyNG2nw==
Date:   Tue, 11 Apr 2023 21:17:52 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <20230412041752.i4raswvrnacnjjgy@treble>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDVft9kysWMfTiZW@FVFF77S0Q05N>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 11, 2023 at 02:25:11PM +0100, Mark Rutland wrote:
> > By your own argument, we cannot rely on the compiler as compiler implementations,
> > optimization strategies, etc can change in ways that are incompatible with any
> > livepatch implementation.
> 
> That's not quite my argument.
> 
> My argument is that if we assume some set of properties that compiler folk
> never agreed to (and were never made aware of), then compiler folk are well
> within their rights to change the compiler such that it doesn't provide those
> properties, and it's very likely that such expectation will be broken. We've
> seen that happen before (e.g. with jump tables).
> 
> Consequently I think we should be working with compiler folk to agree upon some
> solution, where compiler folk will actually try to maintain the properties we
> depend upon (and e.g. they could have tests for). That sort of co-design has
> worked well so far (e.g. with things like kCFI).
> 
> Ideally we'd have people in the same room to have a discussion (e.g. at LPC).

That was the goal of my talk at LPC last year:

  https://lpc.events/event/16/contributions/1392/

We discussed having the compiler annotate the tricky bits of control
flow, mainly jump tables and noreturns.  It's still on my TODO list to
prototype that.

Another alternative which has been suggested in the past by Indu and
others is for objtool to use DWARF/sframe as an input to help guide it
through the tricky bits.

That seems more fragile -- as Madhavan mentioned, GCC-generated DWARF
has some reliability issues -- and also defeats some of the benefits of
reverse-engineering in the first place (we've found many compiler bugs
and other surprising kernel-compiler interactions over the years).

Objtool's understanding of the control flow graph has been really
valuable for reasons beyond live patching (e.g., noinstr and uaccess
validation), it's definitely worth finding a way to make that more
sustainable.

-- 
Josh
