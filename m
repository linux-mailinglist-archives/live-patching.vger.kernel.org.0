Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2511F375730
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhEFPbZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:31:25 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39622 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbhEFPbV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:31:21 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7CC0620B7178;
        Thu,  6 May 2021 08:30:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7CC0620B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620315023;
        bh=oOr6oWLNHl5OnLWE/DfiEsabe3j4uXEH45hDNM9rU+k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=X6aXc3oIkpBHMKkJLeTziMHQ5IMjhZR/dNw7gsy5jn+zxwAkWPgqm9Tg5wW6VVnez
         5OaVLAP3oHl89xq9HwL8VAtPzggXN0sNNdUThakOXFHExpCO8iaB3Ct61p6n17O/8e
         lT0nLF1TCnlrcVtzTpRYRxGLZtJM9Evbq5HKnHLk=
Subject: Re: [RFC PATCH v3 3/4] arm64: Handle miscellaneous functions in .text
 and .init.text
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-4-madvenka@linux.microsoft.com>
 <20210506141211.GE4642@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <8268fde8-5f3b-0781-971b-b29b5e0916cf@linux.microsoft.com>
Date:   Thu, 6 May 2021 10:30:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506141211.GE4642@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/6/21 9:12 AM, Mark Brown wrote:
> On Mon, May 03, 2021 at 12:36:14PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> There are some SYM_CODE functions that are currently in ".text" or
>> ".init.text" sections. Some of these are functions that the unwinder
>> does not care about as they are not "interesting" to livepatch. These
>> will remain in their current sections. The rest I have moved into a
>> new section called ".code.text".
> 
> I was thinking it'd be good to do this by modifying SYM_CODE_START() to
> emit the section, that way nobody can forget to put any SYM_CODE into a
> special section.  That does mean we'd have to first introduce a new
> variant for specifying a section that lets us override things that need
> to be in some specific section and convert everything that's in a
> special section over to that first which is a bit annoying but feels
> like it's worth it for the robustness.  It'd also put some of the don't
> cares into .code.text but so long as they are actually don't cares that
> should be fine!
> 

OK. I could make the section an argument to SYM_CODE*() so that a developer
will never miss that. Some documentation may be in order so the guidelines
are clear. I will do the doc patch separately, if that is alright with
you all.

About the don't car functions - most of them are OK to be moved into
.code.text. But the hypervisor vector related code has a problem. I
have not debugged that yet. If I add that code in .code.text, KVM
initialization fails in one case. In another case, when I actually
test with a VM, the VM does not come up.

I am not sure. But it looks like there may be some reloc issue going on.
I don't have a handle on this yet. So, for now, I will leave the hypervisor
stuff in .text. But I will mark it as TBD in the cover letter so we don't
lose track of it.


>> Don't care functions
>> ====================
> 
> We also have a bunch of things like __cpu_soft_restart which don't seem
> to be called out here but need to be in .idmap.text.
> 

It is already in .idmap.text.



/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * CPU reset routines
 *
 * Copyright (C) 2001 Deep Blue Solutions Ltd.
 * Copyright (C) 2012 ARM Ltd.
 * Copyright (C) 2015 Huawei Futurewei Technologies.
 */

#include <linux/linkage.h>
#include <asm/assembler.h>
#include <asm/sysreg.h>
#include <asm/virt.h>

.text
.pushsection    .idmap.text, "awx"

/*
 * __cpu_soft_restart(el2_switch, entry, arg0, arg1, arg2) - Helper for
 * cpu_soft_restart.
 *
 * @el2_switch: Flag to indicate a switch to EL2 is needed.
 * @entry: Location to jump to for soft reset.
 * arg0: First argument passed to @entry. (relocation list)
 * arg1: Second argument passed to @entry.(physical kernel entry)
 * arg2: Third argument passed to @entry. (physical dtb address)
 *
 * Put the CPU into the same state as it would be if it had been reset, and
 * branch to what would be the reset vector. It must be executed with the
 * flat identity mapping.
 */
SYM_CODE_START(__cpu_soft_restart)
        mov_q   x12, INIT_SCTLR_EL1_MMU_OFF
        pre_disable_mmu_workaround
        /*
         * either disable EL1&0 translation regime or disable EL2&0 translation
         * regime if HCR_EL2.E2H == 1
         */
        msr     sctlr_el1, x12
        isb

        cbz     x0, 1f                          // el2_switch?
        mov     x0, #HVC_SOFT_RESTART
        hvc     #0                              // no return

1:      mov     x8, x1                          // entry
        mov     x0, x2                          // arg0
        mov     x1, x3                          // arg1
        mov     x2, x4                          // arg2
        br      x8
SYM_CODE_END(__cpu_soft_restart)

.popsection


I will double check all the *.S files and make sure that every function is accounted
for in version 4.

Stay tuned.

Thanks.

Madhavan
