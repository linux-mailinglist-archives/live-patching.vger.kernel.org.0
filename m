Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1EC4F945F
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 13:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiDHLoF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 Apr 2022 07:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiDHLoC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 Apr 2022 07:44:02 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B442189A13;
        Fri,  8 Apr 2022 04:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mQ8AKdzMxBFGNBINjR+9BmtRxvC4/CfWJdXWKx3wQT4=; b=m/QV561VZKF+puSKyDHGrf42vS
        xKNxcHw3Zc5G4f4MDCQC0n9n2hdn7NKoZVpNIyNpQ1UvMM/iZh1fSf+E4NkvXegXKu1Bp4K5wXSTT
        1e4VdRp8o9+sNRJ0JbBkTysXUA/9+0wvuBNvNSRehpA16Qffd5YfW3sbbPLNK72G04/txaj9nS9Z/
        EP3JmXAeyjpPHto+zFWczVd1tKqfDRQcLE2nnuK6/2rSEOGI3WvnXmq22lY8rQjrK6q7Cf91ykjri
        NesmJO5qOzsoyapand3YA4CZBgFs2Qv5zblUNNWkjk0wQkUp9zsFkl1pS45RbhmUjnYNhGI1691AK
        em+VAxDg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncmzf-002tVN-F3; Fri, 08 Apr 2022 11:41:35 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id AA0E09861A4; Fri,  8 Apr 2022 13:41:33 +0200 (CEST)
Date:   Fri, 8 Apr 2022 13:41:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     madvenka@linux.microsoft.com, mark.rutland@arm.com,
        broonie@kernel.org, ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        chenzhongjin@huawei.com
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Message-ID: <20220408114133.GP2731@worktop.programming.kicks-ass.net>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408002147.pk7clzruj6sawj7z@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


Right; so not having seen the patches due to Madhaven's email being
broken, I can perhaps less appreciated the crazy involved.

On Thu, Apr 07, 2022 at 05:21:51PM -0700, Josh Poimboeuf wrote:
> 2)
> 
> If I understand correctly, objtool is converting parts of DWARF to a new
> format which can then be read by the kernel.  In that case, please don't
> call it DWARF as that will cause a lot of confusion.
> 
> There are actually several similarities between your new format and ORC,
> which is also an objtool-created DWARF alternative.  It would be
> interesting to see if they could be combined somehow.

What Josh said; please use/extend ORC.

I really don't understand where all this crazy is coming from; why does
objtool need to do something radically weird for ARM64?

There are existing ARM64 patches for objtool; in fact they have recently
been re-posted:

 https://lkml.kernel.org/r/20220407120141.43801-1-chenzhongjin@huawei.com

The only tricky bit seems to be the whole jump-table issue. Using DWARF
as input to deal with jump-tables should be possible -- exceedingly
overkill, but possible I suppose. Mandating DWARF sucks though, compile
times are so much worse with DWARVES on :/

Once objtool can properly follow/validate ARM64 code, it should be
fairly straight forward to have it generate ORC data just like it does
on x86_64.


