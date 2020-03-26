Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A552B193BE2
	for <lists+live-patching@lfdr.de>; Thu, 26 Mar 2020 10:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgCZJaM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Mar 2020 05:30:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:48286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgCZJaM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Mar 2020 05:30:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B694EAF2C;
        Thu, 26 Mar 2020 09:30:10 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] x86/xen: Make the secondary CPU idle tasks
 reliable
To:     Miroslav Benes <mbenes@suse.cz>, boris.ostrovsky@oracle.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, andrew.cooper3@citrix.com, jbeulich@suse.com
References: <20200326092603.7230-1-mbenes@suse.cz>
 <20200326092603.7230-3-mbenes@suse.cz>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <a39c8c7e-c793-7ec1-5159-102c824bdada@suse.com>
Date:   Thu, 26 Mar 2020 10:30:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326092603.7230-3-mbenes@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 26.03.20 10:26, Miroslav Benes wrote:
> The unwinder reports the secondary CPU idle tasks' stack on XEN PV as
> unreliable, which affects at least live patching.
> cpu_initialize_context() sets up the context of the CPU through
> VCPUOP_initialise hypercall. After it is woken up, the idle task starts
> in cpu_bringup_and_idle() function and its stack starts at the offset
> right below pt_regs. The unwinder correctly detects the end of stack
> there but it is confused by NULL return address in the last frame.
> 
> Introduce a wrapper in assembly, which just calls
> cpu_bringup_and_idle(). The return address is thus pushed on the stack
> and the wrapper contains the annotation hint for the unwinder regarding
> the stack state.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
