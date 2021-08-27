Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF453F922D
	for <lists+live-patching@lfdr.de>; Fri, 27 Aug 2021 04:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhH0CCN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Aug 2021 22:02:13 -0400
Received: from linux.microsoft.com ([13.77.154.182]:53250 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhH0CCN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Aug 2021 22:02:13 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id DD70A20B8773;
        Thu, 26 Aug 2021 19:01:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DD70A20B8773
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1630029685;
        bh=OTbKw7Ufng5ajKOqm1ksIBi/arBjO8NRDU0qpEMqC7A=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=XvpH1PyFonB6TJjIAVdCkSAgcICaWcYs6tvq1Y55lTM2qWTnFJsYVwgZFHiq5IL8p
         i61JnIseNSK0gVndaem515Vl2PwK+NR1RWYxoiycEOdHWMxqthWG/Zv5fq9erfzQhx
         Sf1dX14FiUEBhwasl+mqKJvbnLk7gc4KXb/CkBwo=
Subject: Re: announcing LLpatch: arch-independent live-patch creation
To:     Peter Swain <swine@pobox.com>, live-patching@vger.kernel.org
References: <CABFpvm2o+d0e-dfmCx7H6=8i3QQS_xyGFt4i3zn8G=Myr_miag@mail.gmail.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <d8cd311d-dc4c-e81d-286e-2ce4614ddc5e@linux.microsoft.com>
Date:   Thu, 26 Aug 2021 21:01:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CABFpvm2o+d0e-dfmCx7H6=8i3QQS_xyGFt4i3zn8G=Myr_miag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 8/26/21 5:34 PM, Peter Swain wrote:
> We have a new userspace live-patch creation tool, LLpatch, paralleling
> kpatch-build, but without requiring its arch-specific code for ELF
> analysis and manipulation.
> 
> We considered extending kpatch-build to a new target architecture
> (arm64), cluttering its code with details of another architecture’s
> quirky instruction sequences & relocation modes, and suspected there
> might be a better way.
> 
> 
> The LLVM suite already knows these details, and offers llvm-diff, for
> comparing generated code at the LLVM-IR (internal representation)
> level, which has access to much more of the code’s _intent_ than
> kpatch’s create-diff-object is able to infer from ELF-level
> differences.
> 
> 
> Building on this, LLpatch adds namespace analysis, further
> dead/duplicate code elimination, and creation of patch modules
> compatible with kernel’s livepatch API.
> 
> Arm64 is supported - testing against a livepatch-capable v5.12 arm64
> kernel, using the preliminary reliable-stacktrace work from
> madvenka@linux.microsoft.com, LLpatch modules for x86 and arm64 behave
> identically to the x86 kpatch-build modules, without requiring any
> additional arch-specific code.
> 
> On x86, where both tools are available, LLpatch produces smaller patch
> modules than kpatch, and already correctly handles most of the kpatch
> test cases, without any arch-specific code. This suggests it can work
> with any clang-supported kernel architecture.
> 
> 
> Work is ongoing, collaboration is welcome.
> 
> 
> See https://github.com/google/LLpatch for further details on the
> technology and its benefits.
> 
> 
> Yonghyun Hwang (yonghyun@google.com freeaion@gmail.com)
> Bill Wendling (morbo@google.com isanbard@gmail.com)
> Pete Swain (swine@google.com swine@pobox.com)
> 

This is great.

I have implemented an alternative method in objtool to do stack
validation for livepatch purposes. I have successfully built a livepatch
kernel and tested it. I have run all the livepatch tests in the
linux kernel sources successfully.

But I needed kpatch (or something similar) to do more testing. From Josh,
I came to know that a port to ARM64 exists for kpatch. But I was not sure
how well ARM64 was supported.

Since your tool already works on ARM64, I could really use your tool for
my testing. I will study it and contact you with any questions I might
have or any help that I might need. If everything works, I can give
you a "Tested-by".

Thanks.

Madhavan
