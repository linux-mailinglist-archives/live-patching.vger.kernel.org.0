Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8332D38859B
	for <lists+live-patching@lfdr.de>; Wed, 19 May 2021 05:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353218AbhESDk5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 18 May 2021 23:40:57 -0400
Received: from linux.microsoft.com ([13.77.154.182]:59288 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353351AbhESDkF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 18 May 2021 23:40:05 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 36C8B20B7178;
        Tue, 18 May 2021 20:38:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 36C8B20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621395526;
        bh=cS3+zNmc37DC/s8oCI8pYDdc4DHyjueyV5ZDuMOy7PQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MylN2bbW0XXj0O3VEa6/3SW6VVdDKhzlGUN3jF+fu2P0Tx08WPx06fd1F8LvzNP4u
         mrusjH4DDYTQrP9i1l0rpAMjsy6573LihHmlcdJz39mMdrj4haGJ5Tm3+lpDvdsuKB
         ZNSsA2q752/yjdoOcaKejRwaT69cBZ7fzY1y/J7E=
Subject: Re: [RFC PATCH v4 2/2] arm64: Create a list of SYM_CODE functions,
 blacklist them in the unwinder
To:     "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
Cc:     "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "jthierry@redhat.com" <jthierry@redhat.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-3-madvenka@linux.microsoft.com>
 <TY2PR01MB5257FA9C1E94B136E1977790852B9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <da7baa1f-6ee3-ffa4-0b22-73fdde7657a9@linux.microsoft.com>
Date:   Tue, 18 May 2021 22:38:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB5257FA9C1E94B136E1977790852B9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

OK. Thanks for the info. I will be more sensitive and change the name
to something more appropriate.

Madhavan

On 5/18/21 9:06 PM, nobuta.keiya@fujitsu.com wrote:
> Hi Madhavan,
> 
>> +static bool unwinder_blacklisted(unsigned long pc)
>> +{
> 
> I've heard that the Linux community is currently avoiding the introduction of the
> term 'blacklist', see:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=49decddd39e5f6132ccd7d9fdc3d7c470b0061bb
> 
> 
> Thanks & Best Regards,
> Keiya Nobuta
> 
