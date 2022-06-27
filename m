Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0986C55DC71
	for <lists+live-patching@lfdr.de>; Tue, 28 Jun 2022 15:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiF0JnJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jun 2022 05:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiF0JnI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jun 2022 05:43:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E81326F2;
        Mon, 27 Jun 2022 02:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0B16B81063;
        Mon, 27 Jun 2022 09:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11493C3411D;
        Mon, 27 Jun 2022 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656322984;
        bh=GkBQb/LDP/LrppRPZGnpAoFtkcRW5f8iMON0D/lxPKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ohqaX4NzMaVnezuBBavy/jVJkemvk/EzxA99gZyn7wamwnWIPZmcH1FVAeNpFW3zp
         BQz/yjjJVRLDzYRU5Cb/BPJE+VtUklc2ByCg2L0uAUTR7hHq+yOzxE8Gqo4JQewJQx
         RKPs8q5de/TStYY4Z3WR9QktWHR3xidFMkVEUlx1e4pwfdXEFySMQQ8GA3e7qaf7M7
         mlA8gI69LngE6XMFESZopzWiEOiYh1Aze4rDtLQC42TrNngaB9v3h/mzkK0DEFuZoz
         +HG6lHg4Zz5uOyTBv4hEJaLxPqJHWkCysReVOKLB4StLayCycZzLcltwwq5ypJDozm
         /4LTsIonxHhDg==
Date:   Mon, 27 Jun 2022 10:42:58 +0100
From:   Will Deacon <will@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, broonie@kernel.org,
        jpoimboe@redhat.com, ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        maz@kernel.org, Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v15 0/6] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
Message-ID: <20220627094257.GA21634@willie-the-truck>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220623173224.GB16966@willie-the-truck>
 <66545c21-cfcf-60eb-4acf-39be99520369@linux.microsoft.com>
 <YrgkdBtbFmOvKJpX@FVFF77S0Q05N>
 <e1154054-0b5c-6ebf-9f24-8f4f9784f5a5@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1154054-0b5c-6ebf-9f24-8f4f9784f5a5@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, Jun 26, 2022 at 11:48:36PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 6/26/22 04:18, Mark Rutland wrote:
> > On Fri, Jun 24, 2022 at 12:19:01AM -0500, Madhavan T. Venkataraman wrote:
> >>
> >>
> >> On 6/23/22 12:32, Will Deacon wrote:
> >>> On Fri, Jun 17, 2022 at 04:07:11PM -0500, madvenka@linux.microsoft.com wrote:
> >>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >>>>
> >>>> I have synced this patch series to v5.19-rc2.
> >>>> I have also removed the following patch.
> >>>>
> >>>> 	[PATCH v14 7/7] arm64: Select HAVE_RELIABLE_STACKTRACE
> >>>>
> >>>> as HAVE_RELIABLE_STACKTRACE depends on STACK_VALIDATION which is not present
> >>>> yet. This patch will be added in the future once Objtool is enhanced to
> >>>> provide stack validation in some form.
> >>>
> >>> Given that it's not at all obvious that we're going to end up using objtool
> >>> for arm64, does this patch series gain us anything in isolation?
> >>>
> >>
> >> BTW, I have synced my patchset to 5.19-rc2 and sent it as v15.
> >>
> >> So, to answer your question, patches 1 thru 3 in v15 are still useful even if we don't
> >> consider reliable stacktrace. These patches reorganize the unwinder code based on
> >> comments from both Mark Rutland and Mark Brown. Mark Brown has already OKed them.
> >> If Mark Rutland OKes them, we should upstream them.
> > 
> > Sorry for the delay; I have been rather swamped recently and haven't had the
> > time to give this the time it needs.
> > 
> > I'm happy with patches 1 and 2, and I've acked those in case Will wants to pick
> > them.
> > 
> 
> Thanks for the review.
> 
> Will,
> 
> Are you fine with picking up patches 1 and 2?
> 
> For the other patches, I have responded separately.

Sure thing, I'll do that today. Thanks for persevering with this.

Will
