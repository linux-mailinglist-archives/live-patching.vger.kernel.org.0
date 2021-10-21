Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B7E4361AD
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 14:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJUMc4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 08:32:56 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50080 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJUMcq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 08:32:46 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8107020B7179;
        Thu, 21 Oct 2021 05:30:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8107020B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634819430;
        bh=wRzipucQUyVGORKzBSV+cC6ghm4C4V7AbKJUpxlcZEU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NukQe+XcjzleY5DL6QhasbvKGYNgtpTDRM7oU48W0bR3dmTAyotVkE/6XObRyY73t
         gbYaTv6zx3BE/2nR4YIOG4KUE7cmvAWxuQ6U54fzMMbRDQDOowkqqWOiBwMvtXsSZV
         CDREQxgUirptxKHYe/0SxEJwCSi1gUq+o6fTU4AM=
Subject: Re: [PATCH v10 03/11] arm64: Make get_wchan() use arch_stack_walk()
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-4-madvenka@linux.microsoft.com>
 <YXA/eepRCCzL+/jD@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <217ce31e-222b-cc10-f5e1-027e00a49cd4@linux.microsoft.com>
Date:   Thu, 21 Oct 2021 07:30:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXA/eepRCCzL+/jD@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I will take a look at what Peter has done and will coordinate with him.

Thanks.

Madhavan

On 10/20/21 11:10 AM, Mark Brown wrote:
> On Thu, Oct 14, 2021 at 09:58:39PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, get_wchan() in ARM64 code walks the stack using start_backtrace()
>> and unwind_frame(). Make it use arch_stack_walk() instead. This makes
>> maintenance easier.
> 
> This overlaps with some very similar updates that Peter Zijlstra is
> working on which addresses some existing problems with wchan:
> 
> 	https://lore.kernel.org/all/20211008111527.438276127@infradead.org/
> 
> It probably makes sense for you to coordinate with Peter here, some of
> that series is already merged up to his patch 6 which looks very
> similar to what you've got here.  In that thread you'll see that Mark
> Rutland spotted an issue with the handling of __switch_to() on arm64
> which probably also applies to your change.
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
