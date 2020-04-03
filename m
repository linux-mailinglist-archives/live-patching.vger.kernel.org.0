Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4FE19DD6C
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2020 20:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgDCSDf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Apr 2020 14:03:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728219AbgDCSDf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Apr 2020 14:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585937014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CgXbM5tM4nWTswrQ/RgYu+O+1APq3VPj1+jTCpISTXI=;
        b=TRplXgMLJBdi0OeoHS0OWzJOCzuD0a6+qsrXnIBkhmuFD7dQV/NoWFq+De0VPv5Y9CvNW+
        dzm5JCsGnbcYsLh6eGdprkSfszmC9IMgXob1MdYlMljdxd+j7fjxONUXb0VIlJKbS+wgzi
        5JYSGdFAlzqQ67n3Vp1+iQAMNaPCRwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-V9u6mrzrMACNC1HS3NOGKQ-1; Fri, 03 Apr 2020 14:03:33 -0400
X-MC-Unique: V9u6mrzrMACNC1HS3NOGKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42DA88017F6;
        Fri,  3 Apr 2020 18:03:31 +0000 (UTC)
Received: from redhat.com (ovpn-114-27.phx2.redhat.com [10.3.114.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 58F7510002CD;
        Fri,  3 Apr 2020 18:03:30 +0000 (UTC)
Date:   Fri, 3 Apr 2020 14:03:28 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 22/23] livepatch/module: Remove obsolete copy_module_elf()
Message-ID: <20200403180328.GC30284@redhat.com>
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-23-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117150323.21801-23-pmladek@suse.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 17, 2020 at 04:03:22PM +0100, Petr Mladek wrote:
> The split livepatch modules can be relocated immedidately when they
> are loaded. There is no longer needed to preserve the elf sections.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  Documentation/livepatch/module-elf-format.rst | 18 ++++++
>  include/linux/module.h                        |  3 -
>  kernel/module.c                               | 87 ---------------------------
>  3 files changed, 18 insertions(+), 90 deletions(-)
> 
> diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
> index 9f0c997d4940..8c6b894c4661 100644
> --- a/Documentation/livepatch/module-elf-format.rst
> +++ b/Documentation/livepatch/module-elf-format.rst
> @@ -14,6 +14,7 @@ This document outlines the Elf format requirements that livepatch modules must f
>     4. Livepatch symbols
>        4.1 A livepatch module's symbol table
>        4.2 Livepatch symbol format
> +   5. Symbol table and Elf section access
>  
>  1. Background and motivation
>  ============================
> @@ -295,3 +296,20 @@ See include/uapi/linux/elf.h for the actual definitions.
>  [*]
>    Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
>    "OS" means OS-specific.
> +
> +5. Symbol table and Elf section access
> +======================================
> +A livepatch module's symbol table is accessible through module->symtab.
> +
> +Since apply_relocate_add() requires access to a module's section headers,
> +symbol table, and relocation section indices, Elf information is preserved for
> +livepatch modules and is made accessible by the module loader through
> +module->klp_info, which is a klp_modinfo struct. When a livepatch module loads,
> +this struct is filled in by the module loader. Its fields are documented below::
> +
> +	struct klp_modinfo {
> +		Elf_Ehdr hdr; /* Elf header */
> +		Elf_Shdr *sechdrs; /* Section header table */
> +		char *secstrings; /* String table for the section headers */
> +		unsigned int symndx; /* The symbol table section index */
> +	};

I think this file was inadvertently reverted, or at least the Symbol
table and Elf section access section was supposed to stay gone, right?

-- Joe

