Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A438D18B0BC
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2020 11:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCSKBY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Mar 2020 06:01:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:38442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSKBY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Mar 2020 06:01:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4638CB152;
        Thu, 19 Mar 2020 10:01:22 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] x86/xen: Make the boot CPU idle task reliable
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com,
        andrew.cooper3@citrix.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        xen-devel@lists.xenproject.org, jslaby@suse.cz
References: <20200319095606.23627-1-mbenes@suse.cz>
 <20200319095606.23627-2-mbenes@suse.cz>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <71c4eeaf-958a-b215-3033-c3e0d74a9cfa@suse.com>
Date:   Thu, 19 Mar 2020 11:01:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319095606.23627-2-mbenes@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 19.03.2020 10:56, Miroslav Benes wrote:
> The unwinder reports the boot CPU idle task's stack on XEN PV as
> unreliable, which affects at least live patching. There are two reasons
> for this. First, the task does not follow the x86 convention that its
> stack starts at the offset right below saved pt_regs. It allows the
> unwinder to easily detect the end of the stack and verify it. Second,
> startup_xen() function does not store the return address before jumping
> to xen_start_kernel() which confuses the unwinder.
> 
> Amend both issues by moving the starting point of initial stack in
> startup_xen() and storing the return address before the jump, which is
> exactly what call instruction does.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  arch/x86/xen/xen-head.S | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 1d0cee3163e4..edc776af0e0a 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -35,7 +35,11 @@ SYM_CODE_START(startup_xen)
>  	rep __ASM_SIZE(stos)
>  
>  	mov %_ASM_SI, xen_start_info
> -	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
> +#ifdef CONFIG_X86_64
> +	mov initial_stack(%rip), %_ASM_SP
> +#else
> +	mov pa(initial_stack), %_ASM_SP
> +#endif

If you need to distinguish the two anyway, why not use %rsp and
%esp respectively?

Jan
