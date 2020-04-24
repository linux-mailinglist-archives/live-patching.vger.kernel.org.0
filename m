Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917801B7741
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2020 15:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgDXNnM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Apr 2020 09:43:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726926AbgDXNnM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Apr 2020 09:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587735791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X4OZnFlcvX3IqZHJE/SPPyQuprY94beQh1BVXIF1Tvc=;
        b=V8NcKri1MOPuzSazSvs3etbXaOvlQq2r0WZeo5dX6o4qqwZxyWahO+i1CdezXHvgzMOL/L
        zLGrVuL+pmMbwGC/wB+ySPAlZAZol3QJ84CahNYotOzCWF9f2n4ndLYj7ML9IwbaYjLHKs
        zWjWwXKro0s3oCDlV2YEeaPDOxdJsxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-ucB76fxYONKVBrG96cDFDw-1; Fri, 24 Apr 2020 09:43:07 -0400
X-MC-Unique: ucB76fxYONKVBrG96cDFDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 638701005510;
        Fri, 24 Apr 2020 13:43:05 +0000 (UTC)
Received: from treble (ovpn-118-207.rdu2.redhat.com [10.10.118.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 071D85D9CC;
        Fri, 24 Apr 2020 13:43:03 +0000 (UTC)
Date:   Fri, 24 Apr 2020 08:43:01 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200424134301.rug4i5hxtnplahge@treble>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <alpine.LSU.2.21.2004221411140.28581@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2004221411140.28581@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 22, 2020 at 02:28:26PM +0200, Miroslav Benes wrote:
> > +int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
> > +		       unsigned int symindex, unsigned int relsec,
> > +		       struct module *me)
> > +{
> > +	int ret;
> > +	bool early = me->state == MODULE_STATE_UNFORMED;
> > +	void *(*write)(void *, const void *, size_t) = memcpy;
> > +
> > +	if (!early) {
> > +		write = s390_kernel_write;
> > +		mutex_lock(&text_mutex);
> > +	}
> > +
> > +	ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> > +				   write);
> > +
> > +	if (!early)
> > +		mutex_unlock(&text_mutex);
> > +
> > +	return ret;
> > +}
> 
> It means that you can take text_mutex the second time here because it 
> is still taken in klp_init_object_loaded(). It is removed later in the 
> series though. The same applies for x86 patch.
> 
> Also, s390_kernel_write() grabs s390_kernel_write_lock spinlock before 
> writing anything, so maybe text_mutex is not really needed as long as 
> s390_kernel_write is called everywhere for text patching.

Good catch, maybe I'll just drop the text_mutex here.

-- 
Josh

