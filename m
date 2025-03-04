Return-Path: <live-patching+bounces-1253-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6196BA4E576
	for <lists+live-patching@lfdr.de>; Tue,  4 Mar 2025 17:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CBB717EBFD
	for <lists+live-patching@lfdr.de>; Tue,  4 Mar 2025 16:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD6227D786;
	Tue,  4 Mar 2025 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FcZrEQom"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A5A27D779
	for <live-patching@vger.kernel.org>; Tue,  4 Mar 2025 15:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741103466; cv=none; b=bIWAkxYhMzrYBE3wKLgLr7xzn+zmYcwE+tqwVr2laPcl1rm8AB/wuestzuhYEJaML0cDbwTSDmX2F88S8NzStf+fltRGh/2aYMlX2hd2K61zjZZPYYI5QLFuAObUzzYQ5z6tKly5vWKx2N1tsJQWwv26ZJjcJSKSmaabBOpD5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741103466; c=relaxed/simple;
	bh=k2Y27E8jBe6v83yy6OVDayltip9TmWM0y/2df87N2Wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T587XCE4/MY247ftkNx73sXoqP4WXyufhvDJqoc3sYFH2QCDhH+cwKPoscwB1pgChC3wVPlQVacBArmD+LHRugd1KbJ/EdELC2ZssKVN1KQbnlpNI2Md43+iyXMaNEsgdcyeJu7f8D4Y9yPmuGcFuK8P9t2lH1/Srd/0I8M1Q4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FcZrEQom; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-390f5556579so2350212f8f.1
        for <live-patching@vger.kernel.org>; Tue, 04 Mar 2025 07:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741103462; x=1741708262; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ztij9sovDefPZ+JmP5z7McxB3M6gtn8pxDpq2Itdo0g=;
        b=FcZrEQom3rzP6z093pcl2f9PYRpfDj2kSxp0utlBlAZ+tepjWwrw6vLG1mTMZ0tgq9
         9hwgdW6biG8yyR7qb3U12rJHyzhi8B4kCb0qU6zLp1pKkiAUv0Kbn1sE5E6CPVNgmML6
         glA0LJoCOSBnPckQtb548POvMBqHomz6SVXJR/xZ/qakb01gQ61mAtGPt5Hs8Vt8vUEx
         VtROY2f/2ZeDhmTwpbvCgc7USsNiBvFQl8doZlLrs0PEKgnGrPJwt7vlBuCJ9cypII6I
         Tjo08yc7D+CKnJ6RnrSwrAxLxi+t6QONXhlL/fLdaH6xOKzOu7BfEgJHKo5SHfwsq+mX
         RYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741103462; x=1741708262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ztij9sovDefPZ+JmP5z7McxB3M6gtn8pxDpq2Itdo0g=;
        b=v/su75kreB6J7KDk6gjGSDaTErgvVMmd/C3ST/QBUwldxFDbiSmMswZQ+pzv1ShkLl
         LqKItp45JU6Lfv1OW11ProFC1EkwV+f1VGxDAFXQkIVXmFc6lIJVCmtHD/V38ReQB/QD
         Z5EZruFa2BafQe37VU+eRxF+qQ328iT8Uxq6ZglwXQDkt1YJrFTF6+HVM3uR0MGdSDTD
         hweELYp15QG1GwhQlDuOItd95rZqvfCoaDtgYkn0yxB1jyMlz/5BpW72OQPiuiJEj2K3
         H5fp5RwtHMXgLI7VZGfHvH+SwOccCaHVIOQf5eLur0SqqQastM4BveBin3MDZ6A9b7AC
         w/2g==
X-Gm-Message-State: AOJu0YwKG4TJq/p9ny0kZ6mu2nmb0wfo72xEhPWt7lgkQs2lnW5v9jcD
	BmsUv2pBeJdBGboLW7UJ92fxCqKVUULyjz0AxdX1wltYQn3SOf1/TVnvO7yEUcE=
X-Gm-Gg: ASbGncuQnhEgO9QJ4zJKTABaDZoqq9OsTlhuc+IpkR/sSCve3YTLSGGboIc46enwPBB
	Exo3kOuCA6swnxzm4vzyzy14Yx/7TQlb2y1oIeiBHyWr85RE0eBII5dB2hIxpmjWUzN5nL0avu4
	k9YT+vLeKo4qfwEdY9Z+BQqp8bc1eOTHGu9Ch9iSDg26mzMXNgiq+FZRnYkb96vXb+RvwBbEj4E
	7pXrCneGF/gyUshCQgP82MRroES7N1ORh2DT4DN+8a/GA1N/rf488UQWxVLvnjFz3/ssYvd9Ux4
	/3wSmMUXSW87HrX7XerSo6ov88SE+LI1ug==
X-Google-Smtp-Source: AGHT+IEqw732r+HZ4NWu3JQYHrodjvDxnDB1NIugP9b50YqhrS6dPwVXDZpklzhnZ/WuAjHzoYGFCA==
X-Received: by 2002:a05:6000:418a:b0:38f:32a7:b6f3 with SMTP id ffacd0b85a97d-390eca41867mr11311863f8f.40.1741103462172;
        Tue, 04 Mar 2025 07:51:02 -0800 (PST)
Received: from pathway ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bb767a977sm99979765e9.18.2025.03.04.07.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:51:01 -0800 (PST)
Date: Tue, 4 Mar 2025 16:51:00 +0100
From: Petr Mladek <pmladek@suse.com>
To: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
Cc: live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v2] docs: livepatch: move text out of code block
Message-ID: <Z8chZIpQkrp1GZhy@pathway>
References: <20250227163929.141053-1-vincenzo.mezzela@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227163929.141053-1-vincenzo.mezzela@suse.com>

On Thu 2025-02-27 17:39:29, Vincenzo MEZZELA wrote:
> Part of the documentation text is included in the readelf output code
> block. Hence, split the code block and move the affected text outside.
> 
> Signed-off-by: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>

JFYI, the patch has been comitted into livepatching.git,
branch for-6.15/trivial.

Best Regards,
Petr

