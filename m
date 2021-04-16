Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFBB362310
	for <lists+live-patching@lfdr.de>; Fri, 16 Apr 2021 16:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbhDPOo3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Apr 2021 10:44:29 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34918 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245336AbhDPOoO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Apr 2021 10:44:14 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id E19B320B8001;
        Fri, 16 Apr 2021 07:43:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E19B320B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618584229;
        bh=yGPlUqDIzhuFZFcl7DevIoGiDHKMdjiHRYZvWB7Gcdc=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=ZXSTC27GAO2RgkakprT0jpYfaL73I93QUAJQIV4YrY0mJTa87YTXICpw7uxPx/mYG
         lw/qz04hxBR7OWsSldaiBNgZUA/CGR5dOKJ9O1ffAIzGn4uHJhKGpO+/J2wVWYulfV
         goF3hV0R2o8x4WM42VtqTG5MOojqRcDGA30VOj8E=
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <20210412173617.GE5379@sirena.org.uk>
 <d92ec07e-81e1-efb8-b417-d1d8a211ef7f@linux.microsoft.com>
 <20210413110255.GB5586@sirena.org.uk>
 <714e748c-bb79-aa9a-abb5-cf5e677e847b@linux.microsoft.com>
Message-ID: <e8367fe9-6fd0-f962-422d-daa4548cc3b7@linux.microsoft.com>
Date:   Fri, 16 Apr 2021 09:43:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <714e748c-bb79-aa9a-abb5-cf5e677e847b@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/14/21 5:23 AM, Madhavan T. Venkataraman wrote:
> In any case, I have absolutely no problems in implementing your section idea. I will
> make an attempt to do that in version 3 of my patch series.

So, I attempted a patch with just declaring all .entry.text functions as unreliable
by checking just the section bounds. It does work for EL1 exceptions. But there
are other functions that are actually reliable that show up as unreliable.
The example in my test is el0_sync() which is at the base of all system call stacks.

How would you prefer I handle this? Should I place all SYM_CODE functions that
are actually safe for the unwinder in a separate section? I could just take
some approach and solve this. But I would like to get your opinion and Mark
Rutland's opinion so we are all on the same page.

Please let me know.

Madhavan
