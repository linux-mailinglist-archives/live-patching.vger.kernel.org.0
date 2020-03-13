Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3BB184290
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2020 09:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgCMI1D (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Mar 2020 04:27:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:47248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCMI1C (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Mar 2020 04:27:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 01184B22E;
        Fri, 13 Mar 2020 08:26:59 +0000 (UTC)
Subject: Re: [RFC PATCH 2/2] x86/xen: Make the secondary CPU idle tasks
 reliable
To:     Miroslav Benes <mbenes@suse.cz>, boris.ostrovsky@oracle.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz
References: <20200312142007.11488-1-mbenes@suse.cz>
 <20200312142007.11488-3-mbenes@suse.cz>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <75224ad1-f160-802a-9d72-b092ba864fb7@suse.com>
Date:   Fri, 13 Mar 2020 09:26:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312142007.11488-3-mbenes@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12.03.20 15:20, Miroslav Benes wrote:
> The unwinder reports the secondary CPU idle tasks' stack on XEN PV as
> unreliable, which affects at least live patching.
> cpu_initialize_context() sets up the context of the CPU through
> VCPUOP_initialise hypercall. After it is woken up, the idle task starts
> in cpu_bringup_and_idle() function and its stack starts at the offset
> right below pt_regs. The unwinder correctly detects the end of stack
> there but it is confused by NULL return address in the last frame.
> 
> RFC: I haven't found the way to teach the unwinder about the state of
> the stack there. Thus the ugly hack using assembly. Similar to what
> startup_xen() has got for boot CPU.
> 
> It introduces objtool "unreachable instruction" warning just right after
> the jump to cpu_bringup_and_idle(). It should show the idea what needs
> to be done though, I think. Ideas welcome.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
>   arch/x86/xen/smp_pv.c   |  3 ++-
>   arch/x86/xen/xen-head.S | 10 ++++++++++
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
> index 802ee5bba66c..6b88cdcbef8f 100644
> --- a/arch/x86/xen/smp_pv.c
> +++ b/arch/x86/xen/smp_pv.c
> @@ -53,6 +53,7 @@ static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
>   static DEFINE_PER_CPU(struct xen_common_irq, xen_pmu_irq) = { .irq = -1 };
>   
>   static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
> +extern unsigned char asm_cpu_bringup_and_idle[];
>   
>   static void cpu_bringup(void)
>   {

Would adding this here work?

+	asm volatile (UNWIND_HINT(ORC_REG_UNDEFINED, 0, ORC_TYPE_CALL, 1));


Juergen
