Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4D33980
	for <lists+live-patching@lfdr.de>; Mon,  3 Jun 2019 22:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFCUFq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jun 2019 16:05:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfFCUFp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jun 2019 16:05:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71AFB30C0DC6;
        Mon,  3 Jun 2019 20:05:45 +0000 (UTC)
Received: from [10.18.17.208] (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CD58604FE;
        Mon,  3 Jun 2019 20:05:45 +0000 (UTC)
Subject: Re: Reducing the number of ELF section in the livepatch modules
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
References: <7ae3d164-1717-e41b-0683-1779f0e666f2@virtuozzo.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <1f9dd9a3-9bf2-d610-1fc1-8cde1b6501f2@redhat.com>
Date:   Mon, 3 Jun 2019 16:05:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7ae3d164-1717-e41b-0683-1779f0e666f2@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 03 Jun 2019 20:05:45 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 6/3/19 7:14 AM, Evgenii Shatokhin wrote:
> Hi,
> 
> It is possible that keeping each new and patched function in a separate
> ELF section in a livepatch kernel module could cause problems.
> 
> During the testing of binary patches for the kernels used in Virtuozzo
> 7, I found that the kernel may try to allocate a relatively large (for
> kmalloc) memory area to support sysfs files
> /sys/module/<module_name>/sections/* for the patch modules. The size was
> 16 - 35 KB, depending on the patch, i.e. 3rd and 4th order allocations.
> The numbers do not look very big but still increase the chance that the
> patch module will fail to load when the memory is fragmented.
> 
> kernel/module.c, add_sect_attrs():
> 	/* Count loaded sections and allocate structures */
> 	for (i = 0; i < info->hdr->e_shnum; i++)
> 		if (!sect_empty(&info->sechdrs[i]))
> 			nloaded++;
> 	size[0] = ALIGN(sizeof(*sect_attrs)
> 			+ nloaded * sizeof(sect_attrs->attrs[0]),
> 			sizeof(sect_attrs->grp.attrs[0]));
> 	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.attrs[0]);
> 	sect_attrs = kzalloc(size[0] + size[1], GFP_KERNEL);
> 
> So, in our case, the size of the requested memory chunk was
> 48 + 80 * <number_of_loaded_ELF_sections>.
> 
> Both livepatch and old-style KPatch kernel modules place each new or
> patched function in a separate section, same for the new global and
> static data...

Hi Evgenii,

To be specific, I think this is a kpatch-related issue, right?  I don't 
recall there being any section specifications in the upstream livepatch 
code base (aside from arch-specific relocations for alt/para inst, etc.)

 >          ... So, if we patch 200+ kernel functions (which not that
> unusual in cumulative patches), the kernel will try to allocate around
> 16 KB of memory for these sysfs data only. The largest of our binary
> patches have around 400 new and patched functions, plus a few dozens of
> new data items, which results in a wasted kernel memory chunk of 35 KB
> in size.
> 
> Here are the questions.
> 
> 1. The files /sys/module/<module_name>/sections/* currently contain the
> start addresses of the relevant sections, i.e. the addresses of new and
> patched functions among other things. Is this info really needed for
> livepatch kernel modules after they have been loaded?

I think this is generic module debugging info and that livepatch isn't 
interested in these.  I suppose there might be some userspace tools that 
look at those sysfs files for quick verification purposes... though 
there appears to be some filtering of sections that are listed here. 
Not sure which meet the criteria.

> 2. Of course, create-diff-object relies heavily upon placing each new or
> patched function in a separate section. But is it needed to keep the
> functions there after the diff object files have been prepared?
> 
> Does the code that loads/unloads the patches require that each function
> is kept that way? Looks like no, but I am not 100% sure.

Josh will know better than me, but I suspect these sections are just an 
artifact of -ffunction-sections used for the kpatch ELF comparison and 
extraction.

> As an experiment, I added the following to kmod/patch/kpatch.lds.S to
> merge all .text.* sections into .text.livepatch in the resulting patch
> module:
> 
> SECTIONS
> {
> +   .text.livepatch : {
> +    *(.text.*)
> +   }
> 
> My test patch module with around 200 changed functions was built OK with
> that, the functions were actually placed into .text.livepatch section as
> requested. The patch was loaded fine but I haven't tested it much yet.
> 
> It also might be reasonable to merge .rodata.__func__.* the same way.
> 

Nice.  If you have success with this approach, please post up a PR on 
the kpatch github for review.

Also, in the interest of minimizing sections, perhaps the kpatch 
callback and force sections can be omitted if they are unused.  Do they 
count towards the kmalloc allocation you listed above or are they 
skipped when empty?

> Are there any pitfalls in such merging of sections? Am I missing
> something obvious? 
Regards,

-- Joe
