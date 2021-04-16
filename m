Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5717D3626D6
	for <lists+live-patching@lfdr.de>; Fri, 16 Apr 2021 19:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhDPRcW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Apr 2021 13:32:22 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56862 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbhDPRcV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Apr 2021 13:32:21 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id F3E3520B8001;
        Fri, 16 Apr 2021 10:31:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F3E3520B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618594316;
        bh=kwpaa1a5+AiPOWCdlPBsZNZGBHCN4N/Uje1fuen89+o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IBhckXmyPeQdehVc+Ge6lf78wD873wDdIzVc2IdOdNWzKssbmVeRJE5rBCppUoJks
         5IMOTb/2ABmx+DYxhV2TWhBw8x6H6Uy43d/Nqx138jIklqS/zk4J40JUs3T4j8OdCq
         ypx98NhSpkPLFwtXSEMzeAhG/gky4xpQM45JEDXc=
Subject: Re: [RFC PATCH v2 1/1] arm64: Implement stack trace termination
 record
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
 <20210402032404.47239-1-madvenka@linux.microsoft.com>
 <20210402032404.47239-2-madvenka@linux.microsoft.com>
 <20210416161740.GH5560@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <765d0a08-d65f-162b-b20d-07a51b05d984@linux.microsoft.com>
Date:   Fri, 16 Apr 2021 12:31:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210416161740.GH5560@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks!

Madhavan

On 4/16/21 11:17 AM, Mark Brown wrote:
> On Thu, Apr 01, 2021 at 10:24:04PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> Reliable stacktracing requires that we identify when a stacktrace is
>> terminated early. We can do this by ensuring all tasks have a final
>> frame record at a known location on their task stack, and checking
>> that this is the final frame record in the chain.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> 
