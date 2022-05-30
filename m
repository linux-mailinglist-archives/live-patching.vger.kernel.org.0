Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D23653760E
	for <lists+live-patching@lfdr.de>; Mon, 30 May 2022 09:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiE3HxS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 30 May 2022 03:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiE3HxH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 30 May 2022 03:53:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494B0287;
        Mon, 30 May 2022 00:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PA/t+O0nJ8ZID3NeeJjW9bADPDFRaoAD2wrlnvNm2Fc=; b=JA05FiD+94Y9SDtuOfX8qU7/8b
        jQWH1UQ/LOU5p+OQy7OXowgT92X1PEDMGFn8eOHLmFZ5jNS3dia/BQzM8friSrCqpcyAwXOeq/bGA
        Sdh8fWGD3zvA1fweBQ/SVTvosAAa+0/lrhlLUJna7Oj38RVccmcXxeTnUG2kp4q45U41H9UrZoO3V
        J7MkpFmGQKV2c/RYPw4NuksF7YmyZduE7aIimfAS9vxjrv/3eLJ6nenDMKXzCULjpF8W2wLvwh5AX
        fW9xxzVa9+BLNQQWyDwveVUtRVkTHaQQA5sDLJEj1ckFQVAUzlF9MJRKxmzMJD3t4X9n02wa52bep
        ntxwAg7A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvaC0-004I5j-7g; Mon, 30 May 2022 07:52:00 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0B9AC980DE7; Mon, 30 May 2022 09:51:58 +0200 (CEST)
Date:   Mon, 30 May 2022 09:51:57 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Brown <broonie@kernel.org>, jpoimboe@redhat.com,
        chenzhongjin@huawei.com, mark.rutland@arm.com,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 09/20] objtool: arm64: Implement command to invoke
 the decoder
Message-ID: <YpR3naaNCNG9ZJGC@worktop.programming.kicks-ass.net>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220524001637.1707472-10-madvenka@linux.microsoft.com>
 <YoznLR30T+03Ea08@sirena.org.uk>
 <ff58b576-efee-276a-bfb3-11f5d258d580@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff58b576-efee-276a-bfb3-11f5d258d580@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, May 29, 2022 at 09:49:44AM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 5/24/22 09:09, Mark Brown wrote:
> > On Mon, May 23, 2022 at 07:16:26PM -0500, madvenka@linux.microsoft.com wrote:
> >> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >>
> >> Implement a built-in command called cmd_fpv() that can be invoked as
> >> follows:
> >>
> >> 	objtool fpv generate file.o
> >>
> >> The built-in command invokes decode_instructions() to walk each function
> >> and decode the instructions of the function.
> > 
> > In commit b51277eb9775ce91 ("objtool: Ditch subcommands") Josh removed
> > subcommands so this interface is going to need a rethink.
> 
> Thanks for mentioning this. I will sync my patchset to the latest and send out version 3.

Before you do; why are you duplicating lots of validate_branch() ? Why
can't you use the regular code to generate ORC data?

I'm really not happy about all this.
