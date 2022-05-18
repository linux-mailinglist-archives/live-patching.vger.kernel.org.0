Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0681752B1DC
	for <lists+live-patching@lfdr.de>; Wed, 18 May 2022 07:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiERFVY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 May 2022 01:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiERFVW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 May 2022 01:21:22 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1092BC88;
        Tue, 17 May 2022 22:21:21 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id C27DA20F7228;
        Tue, 17 May 2022 22:21:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C27DA20F7228
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1652851281;
        bh=4BLTsh8BTAwezUXtplseUJo4TiCyw+dpXMMGeWrJiiw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FFGekXpTBMvvc8KezrNz87o5jZSM7UAgseEkrQl3qwm1u99JPTaO2gA7XipOoXon1
         7xKkSSGPl00tleJVaxBDcutWIHXCfWYcURSnJ7pUIYipkbgqCIldSNu5GCs6L77fzo
         5OPZXhHJGhzjRQwdn8PzE5h6Cxw/b03OOoPA8slk=
Message-ID: <51836929-57b7-6c75-b19c-2be838cb27ca@linux.microsoft.com>
Date:   Wed, 18 May 2022 00:21:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v14 2/7] arm64: Copy the task argument to unwind_state
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f460a35f88195413bcf7305e5083480aab3ca858>
 <20220413140528.3815-1-madvenka@linux.microsoft.com>
 <20220413140528.3815-3-madvenka@linux.microsoft.com>
 <YnqsXlFO5tPtSXg4@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YnqsXlFO5tPtSXg4@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-21.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks!

On 5/10/22 13:18, Mark Brown wrote:
> On Wed, Apr 13, 2022 at 09:05:23AM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Copy the task argument passed to arch_stack_walk() to unwind_state so that
>> it can be passed to unwind functions via unwind_state rather than as a
>> separate argument. The task is a fundamental part of the unwind state.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
