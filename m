Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5D955A440
	for <lists+live-patching@lfdr.de>; Sat, 25 Jun 2022 00:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiFXWPf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Jun 2022 18:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiFXWPe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Jun 2022 18:15:34 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20C138858F;
        Fri, 24 Jun 2022 15:15:33 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0682620C7943;
        Fri, 24 Jun 2022 15:15:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0682620C7943
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656108932;
        bh=hAvoj8jjZe3egtsndVQDOBocwQja3xej+5CD+Ld/09U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AIM3UBtfsqGjo5ImQw5cmqOAgxzr7cv8le3OqzCp3cdmlFqMIbKU99rUajFZ5jc0k
         2OV8HIVuJSX5C3BqpvV4foKGinW2GXmWmyoOFI9UwrnCAC+BlzFDL0KdXfqN1hZJhZ
         EfnKBYEr12ZFYR4Uzb75eook4yQ4dvvKKYNCzFxk=
Message-ID: <3180d0d3-2a92-13cd-2342-39b8400e3306@linux.microsoft.com>
Date:   Fri, 24 Jun 2022 17:15:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v15 0/6] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, jamorris@linux.microsoft.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220623173224.GB16966@willie-the-truck> <YrWjH4H7KxLAqfph@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YrWjH4H7KxLAqfph@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/24/22 06:42, Mark Brown wrote:
> On Thu, Jun 23, 2022 at 06:32:24PM +0100, Will Deacon wrote:
>> On Fri, Jun 17, 2022 at 04:07:11PM -0500, madvenka@linux.microsoft.com wrote:
> 
>>> as HAVE_RELIABLE_STACKTRACE depends on STACK_VALIDATION which is not present
>>> yet. This patch will be added in the future once Objtool is enhanced to
>>> provide stack validation in some form.
> 
>> Given that it's not at all obvious that we're going to end up using objtool
>> for arm64, does this patch series gain us anything in isolation?
> 
> Having the reliability information seems like it should be useful in
> general even without doing live patching - we can use it to annotate
> stack traces to warn people about anything that might be suspect in
> there.  For live patching it's probably something we'll want regardless
> of the use of objtool, it's one more robustness check which always
> helps.

Hi Mark, Will,

Your comments got me to thinking about the Objtool patch series I have sent earlier.

Since the general feeling is that Objtool is unlikely to be our path to livepatch on ARM64, I think that I can implement what I want in a simpler way as a kernel-only solution. The kernel already has a decoder. I don't need
to provide one. In the kernel-only solution, I don't have to worry about relocations, alternatives, etc, etc.

The number of patches would be about half of the original series with simpler code in many of the patches.

The amount of memory consumed by the CFI entries will most likely be just a fraction of the original series.

I will investigate this. If it works and turns out to be a lot simpler, I will send this as v3 of the livepatch
patch series. Also, if this works, we can replace the various reliability checks with just a single fp validation
check in the unwinder.

Thanks for the input.

Madhavan

