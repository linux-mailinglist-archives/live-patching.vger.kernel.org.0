Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AEA46CE80
	for <lists+live-patching@lfdr.de>; Wed,  8 Dec 2021 08:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhLHHwO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 8 Dec 2021 02:52:14 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41974 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhLHHwO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 8 Dec 2021 02:52:14 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7A5F520B7179;
        Tue,  7 Dec 2021 23:48:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7A5F520B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638949722;
        bh=TYXifds/u8NExxlbMug0Al1QbTIX/Z/0899CkB0rVho=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=ji7waBL1TctUVSrVwB/VwjScz5Za8iSS3PPQrYyDmAPCyFi3rQjGBvcQpo7jxJ+CW
         obBDPp4lotPtF/5LB+o777F3t7Jp8I2lQVpsGBqAS8tl0tzIaTFr7flkeFVrmFmKyz
         jqKthWXdjpi1hQw7xdliXwG5PpZomU6IToUrBAiE=
Subject: Re: Some questions about arm64 live-patching support
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Hubin <hubin57@huawei.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
References: <75f1c581d61d48ec88925ebb4f83d7fd@huawei.com>
 <a72245fa-1c7b-e284-fbb1-5347f227ca5c@linux.microsoft.com>
Message-ID: <8afccf6c-fb24-3aac-d335-7e244d22abe5@linux.microsoft.com>
Date:   Wed, 8 Dec 2021 01:48:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a72245fa-1c7b-e284-fbb1-5347f227ca5c@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Oh, and the other piece that is needed for arm64 is that some re-organization of code is required to
make sure that the functions that are used in patching other functions themselves do not get patched.
Mark Rutland is working on it.

This is work where you can potentially participate. Please contact Mark Rutland, if you are interested.
You can also review Julien Thierry's patchset, if you are interested.

Madhavan

On 12/8/21 1:42 AM, Madhavan T. Venkataraman wrote:
> 
> 
> On 12/7/21 7:49 PM, Hubin wrote:
>> Hi,
>>
>> Currently Linux lacks support for live patching in arm64, and recently we have some patches to help enable this feature.
>> But I still don't know how much gap do we have from finishing arm64 live-patching support.
>> So I just have some questions:
>> 1. What do we need to implement to support aarch64 live-patching?
>> 2. Is there any plan or roadmap for this support?
>> 3. What can I do, if I want to contribute to enabling this feature?
>>
>> Thanks
>>
> 
> Essentially, it needs two pieces:
> 
> 1. The arm64 stack trace code has to supply a reliable stack trace function. Live patch needs that for its
>    consistency model to check if any task in the system is currently executing a function that is being
>    live patched. I am working on that piece right now. The work is being reviewed by Mark Rutland and
>    Mark Brown. We have made good progress on it. I feel that it is fairly close to being accepted.
> 
> 2. Now, the arm64 stack trace code is based on the frame pointer. There needs to be a way to validate the
>    frame pointer. X86 uses a build-time tool called objtool to perform static analysis of objects produced during
>    the kernel build process. It walks each function and makes sure (among other things) that the frame pointer
>    is handled in accordance with calling convention rules. If all the functions examined by the tool pass the
>    checks, the kernel can then be used for live patching.
> 
>    Julien Thierry posted a patchset a while ago for objtool for arm64. Not much has happened on that.
>    I am not sure at this point who is working on it. So, I don't have a clue about its ETA.
> 
>    I am currently working on another solution. This solution validates the frame pointer dynamically
>    rather than statically. It works differently from objtool. I feel that this tool is simpler than objtool.
>    I have successfully run all the selftests (and some new tests that I have written). I plan to post a
>    patchset some time in December. I am sure that there will be a lot of back and forth on it. But I am hoping
>    that the community can converge on something in 2022.
> 
> Madhavan
> 
