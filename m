Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED505591E9
	for <lists+live-patching@lfdr.de>; Fri, 24 Jun 2022 07:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiFXFTE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Jun 2022 01:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXFTE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Jun 2022 01:19:04 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B813462C16;
        Thu, 23 Jun 2022 22:19:03 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id A376F20C709F;
        Thu, 23 Jun 2022 22:19:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A376F20C709F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656047943;
        bh=6qBDSvnipL8L8NZU6lQt3JoRPhECUcPIZ6ydGL4ni+0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ChfwrBSb8V7/ZKqKrqQcTjwTlXnxT4JE+xGNyYNPx+mMwGrfsdiOP1uD8wdfyRdzz
         6AqhpEqhs9MNwyOrjtg0VXvSDKp6dJDb5i+xLGf6tUc0SP98jL202dQsYypGIGvS89
         XxMXXdMJDYWxRuE24U05bav3nAVQ5j/xAXzx4/jc=
Message-ID: <66545c21-cfcf-60eb-4acf-39be99520369@linux.microsoft.com>
Date:   Fri, 24 Jun 2022 00:19:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v15 0/6] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
Content-Language: en-US
To:     Will Deacon <will@kernel.org>
Cc:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220623173224.GB16966@willie-the-truck>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20220623173224.GB16966@willie-the-truck>
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



On 6/23/22 12:32, Will Deacon wrote:
> On Fri, Jun 17, 2022 at 04:07:11PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> I have synced this patch series to v5.19-rc2.
>> I have also removed the following patch.
>>
>> 	[PATCH v14 7/7] arm64: Select HAVE_RELIABLE_STACKTRACE
>>
>> as HAVE_RELIABLE_STACKTRACE depends on STACK_VALIDATION which is not present
>> yet. This patch will be added in the future once Objtool is enhanced to
>> provide stack validation in some form.
> 
> Given that it's not at all obvious that we're going to end up using objtool
> for arm64, does this patch series gain us anything in isolation?
> 

BTW, I have synced my patchset to 5.19-rc2 and sent it as v15.

So, to answer your question, patches 1 thru 3 in v15 are still useful even if we don't
consider reliable stacktrace. These patches reorganize the unwinder code based on
comments from both Mark Rutland and Mark Brown. Mark Brown has already OKed them.
If Mark Rutland OKes them, we should upstream them.

I can drop patches 4 thru 6. Actually, the objtool patch series that I have
sent separately for supporting livepatch already addresses reliability. So, if that
gets reviewed and accepted, we don't even need patches 4 thru 6.

If you are OK with that, I can resend v16 with just patches 1 thru 3. Let me know.

Madhavan

