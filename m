Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723446E1249
	for <lists+live-patching@lfdr.de>; Thu, 13 Apr 2023 18:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjDMQak (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 13 Apr 2023 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMQaj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 13 Apr 2023 12:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8953419A1;
        Thu, 13 Apr 2023 09:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2292B63FE5;
        Thu, 13 Apr 2023 16:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACFCC433D2;
        Thu, 13 Apr 2023 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681403437;
        bh=R1jSvRezl64K+5fLt5AtD+mCONR5KNbY2C7hlkqPgnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pDd/wXv6lizbJJzk7pAd+5P9wxIF9MTUmtkN/++A01BPeiWV4lNSqOeEDXZQOPyxI
         3eCTHeZxQ6oq40N+M6VeTijyTm0PxcgepA3b9fphKrVPYpr9iDasL85QkDZ0nPFD8v
         dq+yGd5RA2hgfbJTEamEoe+FKShnLH+MVsCScSJPmK5AAZy81teGRFwD2HLs5MGba/
         Sc6ExqQHwfIO6SeFZWQ/PfLoE2tr4TqnMeItCavtiDiSbugZI1zPWMfMiv1Mzf8+eP
         cQQkc+ZVE1piXnWMWmjrEZkv+eDx6R4N/Jb8QaMdROi4Ikw/0rbkFmmrbbqtD8Nx1G
         dso6t3Ioj2T/w==
Date:   Thu, 13 Apr 2023 09:30:35 -0700
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
Message-ID: <20230413163035.ttar5uexrpldz3yl@treble>
References: <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N>
 <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
 <20230412050106.7v4s3lalg43i6ciw@treble>
 <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
 <20230412155221.2l2mqsyothseymeq@treble>
 <cf583799-1a8d-4dd2-8bc7-c8fbb07f29ab@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cf583799-1a8d-4dd2-8bc7-c8fbb07f29ab@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 13, 2023 at 09:59:31AM -0500, Madhavan T. Venkataraman wrote:
> On 4/12/23 10:52, Josh Poimboeuf wrote:
> > On Wed, Apr 12, 2023 at 09:50:23AM -0500, Madhavan T. Venkataraman wrote:
> >>>> I read through the SFrame spec file briefly. It looks like I can easily adapt my
> >>>> version 1 of the livepatch patchset which was based on DWARF to SFrame. If the compiler
> >>>> folks agree to properly support and maintain SFrame, then I could send the next version
> >>>> of the patchset based on SFrame.
> >>>>
> >>>> But I kinda need a clear path forward before I implement anything. I request the arm64
> >>>> folks to comment on the above approach. Would it be useful to initiate an email discussion
> >>>> with the compiler folks on what they plan to do to support SFrame? Or, should this all
> >>>> happen face to face in some forum like LPC?
> >>>
> >>> SFrame is basically a simplified version of DWARF unwind, using it as an
> >>> input to objtool is going to have the same issues I mentioned below (and
> >>> as was discussed with your v1).
> >>>
> >>
> >> Yes. It is a much simplified version of DWARF. So, I am hoping that the compiler folks
> >> can provide the feature with a reliability guarantee. DWARF is too complex.
> > 
> > I don't see what the complexity (or lack thereof) of the unwinding data
> > format has to do with it.  The unreliability comes from the underlying
> > data source, not the formatting of the data.
> > 
> 
> What I meant is - if SFrame is implemented by simply extracting unwind info from
> DWARF data and placing it in a separate section (as it is probably implemented now),
> then what you say is totally true. But if the compiler folks agree to make SFrame reliable,
> then either they have to make DWARF reliable. Or, they have to implement SFrame as a
> separate feature and make it reliable. The former is tough to do as DWARF has a lot of complexity.
> The latter is a lot easier to do.

[ adding linux-toolchains ]

I don't think ensuring reliability is an easy task, regardless of the
complexity of the unwinding format.

Whether it's SFrame or DWARF/eh_frame, the question would be how to
ensure it's always reliable for a compiler "power user" like the kernel
which has many edge cases (including lots of inline asm which the
compiler has no visibility to) and which uses unwinding for more than
just debugging.

It would need some kind of black-box testing on a complex code base.
(hint: kind of like what objtool already does today)

-- 
Josh
