Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006D46DFA96
	for <lists+live-patching@lfdr.de>; Wed, 12 Apr 2023 17:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjDLPw0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Apr 2023 11:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjDLPwZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Apr 2023 11:52:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6651A2;
        Wed, 12 Apr 2023 08:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA3A62AB9;
        Wed, 12 Apr 2023 15:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827BAC433D2;
        Wed, 12 Apr 2023 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681314744;
        bh=gT6q8y5ffpQgGV/uEeID8hX6OoQ/VsysCcDOeWP9N1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/2Es4NrtZhuRO80IOiPHW9dtnCa05SNpQ4Wcy8INcjwTdwb9hIH9UHB5mvZerldM
         CvWCNp6BqPk6oLoOv6oYsGsDe8U6LTQcYJTULwU0cXOEbwIMboLgRKyCE9tFGzpkUu
         nKZ4RwaLfOQaqmCgRw8zNEnWMSGm++PQ9o2ji5xkO16l/MySlvZu1eIfLZ0oJMMGQ8
         ZuBidVfJPZKmF81i+xVwLtYKusIFqPtTEMOd/g6FJ6MLsBsbZGbdb6kUWtKhP4zj5n
         FcYFfa6KOYwanDwYGI7xWVpST/RTsWcjbvv2FYgRgwPDI1Ae06vmJFUUQCM0PwsPLp
         w0FEpOInetJKA==
Date:   Wed, 12 Apr 2023 08:52:21 -0700
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
Message-ID: <20230412155221.2l2mqsyothseymeq@treble>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N>
 <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
 <20230412050106.7v4s3lalg43i6ciw@treble>
 <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 12, 2023 at 09:50:23AM -0500, Madhavan T. Venkataraman wrote:
> >> I read through the SFrame spec file briefly. It looks like I can easily adapt my
> >> version 1 of the livepatch patchset which was based on DWARF to SFrame. If the compiler
> >> folks agree to properly support and maintain SFrame, then I could send the next version
> >> of the patchset based on SFrame.
> >>
> >> But I kinda need a clear path forward before I implement anything. I request the arm64
> >> folks to comment on the above approach. Would it be useful to initiate an email discussion
> >> with the compiler folks on what they plan to do to support SFrame? Or, should this all
> >> happen face to face in some forum like LPC?
> > 
> > SFrame is basically a simplified version of DWARF unwind, using it as an
> > input to objtool is going to have the same issues I mentioned below (and
> > as was discussed with your v1).
> > 
> 
> Yes. It is a much simplified version of DWARF. So, I am hoping that the compiler folks
> can provide the feature with a reliability guarantee. DWARF is too complex.

I don't see what the complexity (or lack thereof) of the unwinding data
format has to do with it.  The unreliability comes from the underlying
data source, not the formatting of the data.

-- 
Josh
