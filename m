Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FEF193BDA
	for <lists+live-patching@lfdr.de>; Thu, 26 Mar 2020 10:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgCZJ3o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Mar 2020 05:29:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:47962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgCZJ3n (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Mar 2020 05:29:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D0E3BAF43;
        Thu, 26 Mar 2020 09:29:41 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] x86/xen: Make the boot CPU idle task reliable
To:     Miroslav Benes <mbenes@suse.cz>, boris.ostrovsky@oracle.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, andrew.cooper3@citrix.com, jbeulich@suse.com
References: <20200326092603.7230-1-mbenes@suse.cz>
 <20200326092603.7230-2-mbenes@suse.cz>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <f743b8bd-7552-24a8-e7bc-fa8b3bbcb9d2@suse.com>
Date:   Thu, 26 Mar 2020 10:29:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326092603.7230-2-mbenes@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 26.03.20 10:26, Miroslav Benes wrote:
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

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
