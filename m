Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500C55DF67
	for <lists+live-patching@lfdr.de>; Tue, 28 Jun 2022 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbiF0RE5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jun 2022 13:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiF0RE4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jun 2022 13:04:56 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17A8E13D3D;
        Mon, 27 Jun 2022 10:04:56 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id E07E920CD16D;
        Mon, 27 Jun 2022 10:04:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E07E920CD16D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656349495;
        bh=KQyldYi9aNugtS575gcjHBwv/1KYNMViHcWnCpi8oHw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=q1Fhl1wQAH2cWU/7X4h+HKM34hw+r+ApMkmt7T/tDx5VUBXtp6u6qCxB6l+EcsMiw
         duxTJqQ9Lct0KC54oiDQHhaHbjOhDF+03fYBB7I4aZXSk/8jCmbMHQGaL+w7WighNO
         vkMRWswyX3xyevmgDmkgVmfFtX4JZccfCFVCM6S0=
Message-ID: <89cbbe1f-8f2e-0674-ceb3-1e018e5bf2a4@linux.microsoft.com>
Date:   Mon, 27 Jun 2022 12:04:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v15 0/6] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
Content-Language: en-US
To:     Kalesh Singh <kaleshsingh@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morris <jamorris@linux.microsoft.com>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>
References: <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220623173224.GB16966@willie-the-truck>
 <66545c21-cfcf-60eb-4acf-39be99520369@linux.microsoft.com>
 <YrgkdBtbFmOvKJpX@FVFF77S0Q05N>
 <b7f62c2e-b2ef-1528-d126-b2e0c001a7c4@linux.microsoft.com>
 <CAC_TJveqCTToimvrrTrEcRAxERL0EW+61PxS9emb-u51Eo4Eug@mail.gmail.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <CAC_TJveqCTToimvrrTrEcRAxERL0EW+61PxS9emb-u51Eo4Eug@mail.gmail.com>
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



On 6/27/22 11:32, Kalesh Singh wrote:
> On Sun, Jun 26, 2022 at 9:33 PM Madhavan T. Venkataraman
> <madvenka@linux.microsoft.com> wrote:
>>
>>
>>
>> On 6/26/22 04:18, Mark Rutland wrote:
>>> On Fri, Jun 24, 2022 at 12:19:01AM -0500, Madhavan T. Venkataraman wrote:
>>>>
>>>>
>>>> On 6/23/22 12:32, Will Deacon wrote:
>>>>> On Fri, Jun 17, 2022 at 04:07:11PM -0500, madvenka@linux.microsoft.com wrote:
>>>>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>>>>
>>>>>> I have synced this patch series to v5.19-rc2.
>>>>>> I have also removed the following patch.
>>>>>>
>>>>>>    [PATCH v14 7/7] arm64: Select HAVE_RELIABLE_STACKTRACE
>>>>>>
>>>>>> as HAVE_RELIABLE_STACKTRACE depends on STACK_VALIDATION which is not present
>>>>>> yet. This patch will be added in the future once Objtool is enhanced to
>>>>>> provide stack validation in some form.
>>>>>
>>>>> Given that it's not at all obvious that we're going to end up using objtool
>>>>> for arm64, does this patch series gain us anything in isolation?
>>>>>
>>>>
>>>> BTW, I have synced my patchset to 5.19-rc2 and sent it as v15.
>>>>
>>>> So, to answer your question, patches 1 thru 3 in v15 are still useful even if we don't
>>>> consider reliable stacktrace. These patches reorganize the unwinder code based on
>>>> comments from both Mark Rutland and Mark Brown. Mark Brown has already OKed them.
>>>> If Mark Rutland OKes them, we should upstream them.
>>>
>>> Sorry for the delay; I have been rather swamped recently and haven't had the
>>> time to give this the time it needs.
>>>
>>> I'm happy with patches 1 and 2, and I've acked those in case Will wants to pick
>>> them.
>>>
>>> Kalesh (cc'd) is working to share the unwinder code with hyp, and I think that
>>> we need to take a step back and consider how we can make the design work
>>> cleanly with that. I'd had a go at prototyping making the unwinder more data
>>> driven, but I haven't come up with something satisfactory so far.
>>>
>>> It would be good if you could look at / comment on each others series.
>>>
>>
>> I will review Kalesh's unwinder changes.
> 
> Thanks Mark, I'll take a look.
> 
> Madhavan, I'm in the process of preparing a new version. Let me rebase
> on your first 2 patches and resend, so you can look at that version
> instead.
> 

Sure thing.

Thanks.

Madhavan
